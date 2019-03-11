"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const autoscaling_1 = require("./helper/autoscaling");
const types_1 = require("./helper/autoscaling/types");
const queue_1 = require("./helper/queue");
const manager_1 = require("./helper/manager");
const messages_1 = require("./constant/messages");
exports.handler = async (event, context) => {
    try {
        const { Event } = JSON.parse(event.Records[0].body);
        if (Event === types_1.LifecycleEvent.TestNotification) {
            await queue_1.deleteQueueTask(event, process.env.SQS_QUEUE_URL);
            return context.succeed(messages_1.HandlerMessages.TestNotificationHandled);
        }
        const refreshTimeout = parseInt(process.env.TASK_REFRESH_TIMEOUT, 10);
        if (!await manager_1.isInSystemManager(event)) {
            await queue_1.refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
            return context.fail(messages_1.HandlerMessages.TaskHandlingDelayed);
        }
        if (await autoscaling_1.isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
            await autoscaling_1.refreshLifecycle(event);
            await manager_1.runCommand(event, process.env.NODE_RUNTIME_INSTALL_COMMAND, {
                KubernetesVersion: [process.env.KUBERNETES_VERSION],
                DockerVersion: [process.env.DOCKER_VERSION],
            });
            await manager_1.runCommand(event, process.env.COMMON_WORKER_INIT_COMMAND, {
                S3BucketName: [process.env.S3_BUCKED_NAME],
            });
            await autoscaling_1.setInstanceTags(event, [
                { Key: types_1.TagName.NodeState, Value: types_1.NodeState.NodeInitialized },
                { Key: types_1.TagName.NodeRole, Value: types_1.NodeRole.WorkerNode },
            ]);
            await autoscaling_1.completeLifecycle(event, types_1.LifecycleResult.Continue);
            await queue_1.deleteQueueTask(event, process.env.SQS_QUEUE_URL);
            return context.succeed(messages_1.HandlerMessages.WorkerNodeInitialized);
        }
        await queue_1.refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
        return context.fail(messages_1.HandlerMessages.TaskHandlingDelayed);
    }
    catch (exception) {
        await queue_1.deleteQueueTask(event, process.env.SQS_QUEUE_URL);
        await autoscaling_1.completeLifecycle(event, types_1.LifecycleResult.Abandon);
        throw exception;
    }
};
