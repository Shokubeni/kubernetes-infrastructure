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
const autoscaling_1 = require("./helper/autoscaling");
const types_1 = require("./helper/autoscaling/types");
const queue_1 = require("./helper/queue");
const manager_1 = require("./helper/manager");
const messages_1 = require("./constant/messages");
const s3_1 = require("./helper/s3");
exports.handler = (event, context) => __awaiter(this, void 0, void 0, function* () {
    try {
        const { Event } = JSON.parse(event.Records[0].body);
        if (Event === types_1.LifecycleEvent.TestNotification) {
            yield queue_1.deleteQueueTask(event, process.env.SQS_QUEUE_URL);
            return context.succeed(messages_1.HandlerMessages.TestNotificationHandled);
        }
        const refreshTimeout = parseInt(process.env.TASK_REFRESH_TIMEOUT, 10);
        const executeLimit = parseInt(process.env.TASK_EXECUTE_LIMIT, 10);
        if (!(yield manager_1.isInSystemManager(event))) {
            yield queue_1.refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
            return context.fail(messages_1.HandlerMessages.TaskHandlingDelayed);
        }
        if (yield autoscaling_1.isQueueControlReturn(event, process.env.MASTER_AUTOSCALING_GROUP)) {
            const controlTimeout = Math.ceil(Math.random() * 30);
            yield autoscaling_1.setInstanceTags(event, [
                { Key: types_1.TagName.NodeState, Value: types_1.NodeState.InitAwaiting },
                { Key: types_1.TagName.NodeRole, Value: types_1.NodeRole.MaterNode },
            ]);
            yield queue_1.refreshQueueTask(event, process.env.SQS_QUEUE_URL, controlTimeout);
            return context.fail(messages_1.HandlerMessages.TaskHandlingDelayed);
        }
        if (yield autoscaling_1.isMasterConcurrency(process.env.MASTER_AUTOSCALING_GROUP)) {
            yield queue_1.refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
            return context.fail(messages_1.HandlerMessages.TaskHandlingDelayed);
        }
        yield autoscaling_1.setInstanceTags(event, [
            { Key: types_1.TagName.NodeState, Value: types_1.NodeState.InitProcessing },
            { Key: types_1.TagName.NodeRole, Value: types_1.NodeRole.MaterNode },
        ]);
        yield queue_1.refreshQueueTask(event, process.env.SQS_QUEUE_URL, executeLimit);
        yield manager_1.runCommand(event, process.env.NODE_RUNTIME_INSTALL_COMMAND, {
            KubernetesVersion: [process.env.KUBERNETES_VERSION],
            DockerVersion: [process.env.DOCKER_VERSION],
        });
        if (yield autoscaling_1.isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
            yield autoscaling_1.refreshLifecycle(event);
            yield manager_1.runCommand(event, process.env.STACKED_MASTER_INIT_COMMAND, {
                S3BucketRegion: [process.env.S3_BUCKET_REGION],
                S3BucketName: [process.env.S3_BUCKED_NAME],
                ClusterId: [process.env.CLUSTER_ID],
            });
            yield autoscaling_1.completeLifecycle(event, types_1.LifecycleResult.Continue);
        }
        else {
            const snapshotName = yield s3_1.getLastSnapshot(process.env.S3_BACKUP_BUCKET);
            yield autoscaling_1.completeLifecycle(event, types_1.LifecycleResult.Continue);
            if (!snapshotName) {
                yield manager_1.runCommand(event, process.env.GENERAL_MASTER_INIT_COMMAND, {
                    S3BucketRegion: [process.env.S3_BUCKET_REGION],
                    S3BucketName: [process.env.S3_BUCKED_NAME],
                    BalancerDNS: [process.env.LOAD_BALANCER_DNS],
                    ClusterId: [process.env.CLUSTER_ID],
                });
            }
            else {
                yield manager_1.runCommand(event, process.env.GENERAL_MASTER_RESTORE_COMMAND, {
                    S3BucketRegion: [process.env.S3_BUCKET_REGION],
                    S3BucketName: [process.env.S3_BUCKED_NAME],
                    ClusterId: [process.env.CLUSTER_ID],
                    SnapshotName: [snapshotName],
                });
            }
        }
        yield autoscaling_1.setInstanceTags(event, [
            { Key: types_1.TagName.NodeState, Value: types_1.NodeState.InitFinished },
            { Key: types_1.TagName.NodeRole, Value: types_1.NodeRole.MaterNode },
        ]);
        yield queue_1.deleteQueueTask(event, process.env.SQS_QUEUE_URL);
        return context.succeed(messages_1.HandlerMessages.MasterNodeInitialized);
    }
    catch (exception) {
        yield queue_1.deleteQueueTask(event, process.env.SQS_QUEUE_URL);
        yield autoscaling_1.completeLifecycle(event, types_1.LifecycleResult.Abandon);
        throw exception;
    }
});
