import { TagsList } from 'aws-sdk/clients/cloudtrail';
import { AutoScaling, EC2 } from 'aws-sdk';
import { SQSEvent } from 'aws-lambda';
import {
  RecordLifecycleActionHeartbeatType,
  CompleteLifecycleActionType,
  AutoScalingGroupNamesType, Instances,
} from 'aws-sdk/clients/autoscaling';
import {
  DescribeTagsRequest,
  CreateTagsRequest,
  TagDescriptionList,
  FilterList,
  InstanceId,
} from 'aws-sdk/clients/ec2';

import { HealthStatus, LifecycleState, NodeState, TagName, LifecycleResult } from './types';

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
    const instances = Instances
      .filter((instance) => {
        const isInService = instance.LifecycleState === LifecycleState.InService;
        const isHealthy = instance.HealthStatus === HealthStatus.Healthy;
        return isInService && isHealthy;
      });

    if (instances.length > 0) {
      for (let i = 0; i < instances.length; i = i + 1) {
        const tags = await getInstanceTags(instances[i].InstanceId, [{
          Values: [TagName.NodeState], Name: 'key',
        }]);

        if (tags.length > 0) {
          const result = tags.some((tag) => {
            return tag.Key === TagName.NodeState &&
              tag.Value === NodeState.InitFinished;
          });

          if (result) {
            return true;
          }
        }
      }
    }
  }

  return false;
}

export async function isMasterConcurrency(groupName: string): Promise<boolean> {
  const result = await autoScalingGroup
    .describeAutoScalingGroups({
      AutoScalingGroupNames: [groupName],
    } as AutoScalingGroupNamesType)
    .promise();

  const { Instances } = result.AutoScalingGroups[0];
  if (Instances) {
    const checkTypes = [
      LifecycleState.Pending, LifecycleState.PendingWait, LifecycleState.PendingProceed,
    ];

    const inProgressInstances = Instances
      .filter((instance) => {
        const isInProgress = checkTypes.includes(instance.LifecycleState as LifecycleState);
        const isHealthy = instance.HealthStatus === HealthStatus.Healthy;
        return isInProgress && isHealthy;
      });

    if (inProgressInstances.length > 0) {
      for (let i = 0; i < inProgressInstances.length; i = i + 1) {
        const tags = await getInstanceTags(inProgressInstances[i].InstanceId, [{
          Values: [TagName.NodeState], Name: 'key',
        }]);

        if (tags.length > 0) {
          const isTagsExists = tags.some((tag) => {
            return tag.Key === TagName.NodeState &&
              tag.Value === NodeState.InitProcessing;
          });

          if (isTagsExists) {
            return true;
          }
        }
      }
    }
  }

  return false;
}

export async function getMasterNodeId(groupName: string): Promise<InstanceId|null> {
  const result = await autoScalingGroup
    .describeAutoScalingGroups({
      AutoScalingGroupNames: [groupName],
    } as AutoScalingGroupNamesType)
    .promise();

  const { Instances } = result.AutoScalingGroups[0];
  if (Instances) {
    const instances = Instances
      .filter((instance) => {
        const isInService = instance.LifecycleState === LifecycleState.InService;
        const isHealthy = instance.HealthStatus === HealthStatus.Healthy;
        return isInService && isHealthy;
      });

    if (instances.length > 0) {
      for (let i = 0; i < instances.length; i = i + 1) {
        const tags = await getInstanceTags(instances[i].InstanceId, [{
          Values: [TagName.NodeState], Name: 'key',
        }]);

        if (tags.length > 0) {
          const isTagsExists = tags.some((tag) => {
            return tag.Key === TagName.NodeState &&
              tag.Value === NodeState.InitFinished;
          });

          if (isTagsExists) {
            return instances[i].InstanceId;
          }
        }
      }
    }
  }

  return null;
}
