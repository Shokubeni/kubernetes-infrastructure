"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const aws_sdk_1 = require("aws-sdk");
const types_1 = require("./types");
const autoScalingGroup = new aws_sdk_1.AutoScaling();
const ec2 = new aws_sdk_1.EC2();
function completeLifecycle(event, result) {
    return __awaiter(this, void 0, void 0, function* () {
        const { AutoScalingGroupName, LifecycleActionToken, LifecycleHookName, EC2InstanceId, } = JSON.parse(event.Records[0].body);
        yield autoScalingGroup
            .completeLifecycleAction({
            AutoScalingGroupName,
            LifecycleActionToken,
            LifecycleHookName,
            LifecycleActionResult: result,
            InstanceId: EC2InstanceId,
        })
            .promise();
    });
}
exports.completeLifecycle = completeLifecycle;
function refreshLifecycle(event) {
    return __awaiter(this, void 0, void 0, function* () {
        const { AutoScalingGroupName, LifecycleActionToken, LifecycleHookName, EC2InstanceId, } = JSON.parse(event.Records[0].body);
        yield autoScalingGroup
            .recordLifecycleActionHeartbeat({
            AutoScalingGroupName,
            LifecycleActionToken,
            LifecycleHookName,
            InstanceId: EC2InstanceId,
        })
            .promise();
    });
}
exports.refreshLifecycle = refreshLifecycle;
function setInstanceTags(event, tags) {
    return __awaiter(this, void 0, void 0, function* () {
        const instanceId = (typeof event === 'object')
            ? JSON.parse(event.Records[0].body).EC2InstanceId
            : event;
        yield ec2
            .createTags({
            Resources: [instanceId],
            Tags: tags,
        })
            .promise();
    });
}
exports.setInstanceTags = setInstanceTags;
function getInstanceTags(event, filters) {
    return __awaiter(this, void 0, void 0, function* () {
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
    });
}
exports.getInstanceTags = getInstanceTags;
function isMasterNodeExists(groupName) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = yield autoScalingGroup
            .describeAutoScalingGroups({
            AutoScalingGroupNames: [groupName],
        })
            .promise();
        const { Instances } = result.AutoScalingGroups[0];
        if (Instances) {
            const instances = Instances
                .filter((instance) => {
                const isInService = instance.LifecycleState === types_1.LifecycleState.InService;
                const isHealthy = instance.HealthStatus === types_1.HealthStatus.Healthy;
                return isInService && isHealthy;
            });
            if (instances.length > 0) {
                for (let i = 0; i < instances.length; i = i + 1) {
                    const tags = yield getInstanceTags(instances[i].InstanceId, [{
                            Values: [types_1.TagName.NodeState], Name: 'key',
                        }]);
                    if (tags.length > 0) {
                        const result = tags.some((tag) => {
                            return tag.Key === types_1.TagName.NodeState &&
                                tag.Value === types_1.NodeState.InitFinished;
                        });
                        if (result) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    });
}
exports.isMasterNodeExists = isMasterNodeExists;
function isQueueControlReturn(event, groupName) {
    return __awaiter(this, void 0, void 0, function* () {
        const instanceId = (typeof event === 'object')
            ? JSON.parse(event.Records[0].body).EC2InstanceId
            : event;
        const result = yield autoScalingGroup
            .describeAutoScalingGroups({
            AutoScalingGroupNames: [groupName],
        })
            .promise();
        const { Instances } = result.AutoScalingGroups[0];
        if (Instances) {
            const checkTypes = [
                types_1.LifecycleState.Pending,
                types_1.LifecycleState.PendingWait,
                types_1.LifecycleState.PendingProceed,
                types_1.LifecycleState.InService,
            ];
            const inProgressInstances = Instances
                .filter((instance) => {
                const isInProgress = checkTypes.includes(instance.LifecycleState);
                const isHealthy = instance.HealthStatus === types_1.HealthStatus.Healthy;
                return isInProgress && isHealthy;
            });
            const currentInstanceTags = yield getInstanceTags(instanceId, [{
                    Values: [types_1.TagName.NodeState], Name: 'key',
                }]);
            const isInitializeAwait = currentInstanceTags.some((tag) => {
                return tag.Key === types_1.TagName.NodeState &&
                    tag.Value !== types_1.NodeState.InitAwaiting;
            });
            return (inProgressInstances.length > 1) && (currentInstanceTags.length === 0 || isInitializeAwait);
        }
        return false;
    });
}
exports.isQueueControlReturn = isQueueControlReturn;
function isMasterConcurrency(groupName) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = yield autoScalingGroup
            .describeAutoScalingGroups({
            AutoScalingGroupNames: [groupName],
        })
            .promise();
        const { Instances } = result.AutoScalingGroups[0];
        if (Instances) {
            const checkTypes = [
                types_1.LifecycleState.Pending,
                types_1.LifecycleState.PendingWait,
                types_1.LifecycleState.PendingProceed,
                types_1.LifecycleState.InService,
            ];
            const inProgressInstances = Instances
                .filter((instance) => {
                const isInProgress = checkTypes.includes(instance.LifecycleState);
                const isHealthy = instance.HealthStatus === types_1.HealthStatus.Healthy;
                return isInProgress && isHealthy;
            });
            if (inProgressInstances.length > 0) {
                for (let i = 0; i < inProgressInstances.length; i = i + 1) {
                    const tags = yield getInstanceTags(inProgressInstances[i].InstanceId, [{
                            Values: [types_1.TagName.NodeState], Name: 'key',
                        }]);
                    if (tags.length > 0) {
                        const isTagsExists = tags.some((tag) => {
                            return tag.Key === types_1.TagName.NodeState &&
                                tag.Value === types_1.NodeState.InitProcessing;
                        });
                        if (isTagsExists) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    });
}
exports.isMasterConcurrency = isMasterConcurrency;
function getMasterNodeId(groupName) {
    return __awaiter(this, void 0, void 0, function* () {
        const result = yield autoScalingGroup
            .describeAutoScalingGroups({
            AutoScalingGroupNames: [groupName],
        })
            .promise();
        const { Instances } = result.AutoScalingGroups[0];
        if (Instances) {
            const instances = Instances
                .filter((instance) => {
                const isInService = instance.LifecycleState === types_1.LifecycleState.InService;
                const isHealthy = instance.HealthStatus === types_1.HealthStatus.Healthy;
                return isInService && isHealthy;
            });
            if (instances.length > 0) {
                for (let i = 0; i < instances.length; i = i + 1) {
                    const tags = yield getInstanceTags(instances[i].InstanceId, [{
                            Values: [types_1.TagName.NodeState], Name: 'key',
                        }]);
                    if (tags.length > 0) {
                        const isTagsExists = tags.some((tag) => {
                            return tag.Key === types_1.TagName.NodeState &&
                                tag.Value === types_1.NodeState.InitFinished;
                        });
                        if (isTagsExists) {
                            return instances[i].InstanceId;
                        }
                    }
                }
            }
        }
        return null;
    });
}
exports.getMasterNodeId = getMasterNodeId;
