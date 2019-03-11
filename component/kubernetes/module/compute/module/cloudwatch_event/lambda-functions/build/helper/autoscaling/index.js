"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const aws_sdk_1 = require("aws-sdk");
const types_1 = require("./types");
const autoScalingGroup = new aws_sdk_1.AutoScaling();
const ec2 = new aws_sdk_1.EC2();
async function setInstanceTags(event, tags) {
    const instanceId = (typeof event === 'object')
        ? JSON.parse(event.Records[0].body).EC2InstanceId
        : event;
    await ec2
        .createTags({
        Resources: [instanceId],
        Tags: tags,
    })
        .promise();
}
exports.setInstanceTags = setInstanceTags;
async function getInstanceTags(event, filters) {
    const instanceId = (typeof event === 'object')
        ? JSON.parse(event.Records[0].body).EC2InstanceId
        : event;
    return ec2
        .describeTags({
        Filters: [...filters, { Values: [instanceId], Name: 'resource-id' }],
    })
        .promise()
        .then((result) => {
        return result.Tags ? result.Tags : [];
    });
}
exports.getInstanceTags = getInstanceTags;
async function isMasterNodeExists(groupName) {
    const result = await autoScalingGroup
        .describeAutoScalingGroups({
        AutoScalingGroupNames: [groupName],
    })
        .promise();
    const { Instances } = result.AutoScalingGroups[0];
    if (Instances) {
        const instance = Instances
            .find((instance) => {
            const isInService = instance.LifecycleState === types_1.LifecycleState.InService;
            const isHealthy = instance.HealthStatus === types_1.HealthStatus.Healthy;
            return isInService && isHealthy;
        });
        if (instance) {
            const tags = await getInstanceTags(instance.InstanceId, [{
                    Values: [types_1.TagName.NodeState], Name: 'key',
                }]);
            if (tags.length > 0) {
                return tags.some((tag) => {
                    return tag.Key === types_1.TagName.NodeState &&
                        tag.Value === types_1.NodeState.NodeInitialized;
                });
            }
        }
    }
    return false;
}
exports.isMasterNodeExists = isMasterNodeExists;
async function getMasterNodeId(groupName) {
    const result = await autoScalingGroup
        .describeAutoScalingGroups({
        AutoScalingGroupNames: [groupName],
    })
        .promise();
    const { Instances } = result.AutoScalingGroups[0];
    if (Instances) {
        const instance = Instances
            .find((instance) => {
            const isInService = instance.LifecycleState === types_1.LifecycleState.InService;
            const isHealthy = instance.HealthStatus === types_1.HealthStatus.Healthy;
            return isInService && isHealthy;
        });
        if (instance) {
            const tags = await getInstanceTags(instance.InstanceId, [{
                    Values: [types_1.TagName.NodeState], Name: 'key',
                }]);
            if (tags.length > 0) {
                const isTagsExists = tags.some((tag) => {
                    return tag.Key === types_1.TagName.NodeState &&
                        tag.Value === types_1.NodeState.NodeInitialized;
                });
                return isTagsExists ? instance.InstanceId : null;
            }
        }
    }
    return null;
}
exports.getMasterNodeId = getMasterNodeId;
