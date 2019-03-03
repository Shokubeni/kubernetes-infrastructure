import { TagsList } from 'aws-sdk/clients/cloudtrail';
import { AutoScaling, EC2 } from 'aws-sdk';
import { SQSEvent } from 'aws-lambda';
import {
  RecordLifecycleActionHeartbeatType,
  CompleteLifecycleActionType,
  AutoScalingGroupNamesType,
} from 'aws-sdk/clients/autoscaling';
import {
  DescribeTagsRequest,
  CreateTagsRequest,
  TagDescriptionList,
  FilterList,
  InstanceId,
} from 'aws-sdk/clients/ec2';

import { HealthStatus, LifecycleResult, LifecycleState, NodeState, TagName } from './types';

const autoScalingGroup = new AutoScaling();
const ec2 = new EC2();

export async function completeLifecycle(event: SQSEvent, result: LifecycleResult): Promise<void> {
  const {
    AutoScalingGroupName,
    LifecycleActionToken,
    LifecycleHookName,
    EC2InstanceId,
  } = JSON.parse(event.Records[0].body);

  await autoScalingGroup
    .completeLifecycleAction({
      AutoScalingGroupName,
      LifecycleActionToken,
      LifecycleHookName,
      LifecycleActionResult: result,
      InstanceId: EC2InstanceId,
    } as CompleteLifecycleActionType)
    .promise();
}

export async function refreshLifecycle(event: SQSEvent): Promise<void> {
  const {
    AutoScalingGroupName,
    LifecycleActionToken,
    LifecycleHookName,
    EC2InstanceId,
  } = JSON.parse(event.Records[0].body);

  await autoScalingGroup
    .recordLifecycleActionHeartbeat({
      AutoScalingGroupName,
      LifecycleActionToken,
      LifecycleHookName,
      InstanceId: EC2InstanceId,
    } as RecordLifecycleActionHeartbeatType)
    .promise();
}

export async function setInstanceTags(event: SQSEvent|InstanceId, tags: TagsList): Promise<void> {
  const instanceId = (typeof event === 'object')
    ? JSON.parse(event.Records[0].body).EC2InstanceId
    : event;

  await ec2
    .createTags({
      Resources: [instanceId],
      Tags: tags,
    } as CreateTagsRequest)
    .promise();
}

export async function getInstanceTags(event: SQSEvent|InstanceId, filters: FilterList): Promise<TagDescriptionList> {
  const instanceId = (typeof event === 'object')
    ? JSON.parse(event.Records[0].body).EC2InstanceId
    : event;

  return ec2
    .describeTags({
      Filters: [...filters, { Values: [instanceId], Name: 'resource-id' }],
    } as DescribeTagsRequest)
    .promise()
    .then((result) => {
      return result.Tags ? result.Tags : [];
    });
}

export async function isMasterNodeExists(groupName: string): Promise<boolean> {
  const result = await autoScalingGroup
    .describeAutoScalingGroups({
      AutoScalingGroupNames: [groupName],
    } as AutoScalingGroupNamesType)
    .promise();

  const { Instances } = result.AutoScalingGroups[0];
  if (Instances) {
    const instance = Instances
      .find((instance) => {
        const isInService = instance.LifecycleState === LifecycleState.InService;
        const isHealthy = instance.HealthStatus === HealthStatus.Healthy;
        return isInService && isHealthy;
      });

    if (instance) {
      const tags = await getInstanceTags(instance.InstanceId, [{
        Values: [TagName.NodeState], Name: 'key',
      }]);

      if (tags.length > 0) {
        return tags.some((tag) => {
          return tag.Key === TagName.NodeState &&
            tag.Value === NodeState.NodeInitialized;
        });
      }
    }
  }

  return false;
}