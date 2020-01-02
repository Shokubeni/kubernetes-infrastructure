import { SQSEvent, Context } from 'aws-lambda';

import {
  completeLifecycle,
  isMasterConcurrency,
  isMasterNodeExists,
  isQueueControlReturn,
  refreshLifecycle,
  setInstanceTags,
} from './helper/autoscaling';
import { LifecycleEvent, LifecycleResult, NodeRole, NodeState, TagName } from './helper/autoscaling/types';
import { deleteQueueTask, refreshQueueTask } from './helper/queue';
import { runCommand, isInSystemManager } from './helper/manager';
import { HandlerMessages } from './constant/messages';
import { getLastSnapshot } from './helper/s3';

declare var process : {
  env: {
    NODE_RUNTIME_INSTALL_COMMAND: string,
    GENERAL_MASTER_RESTORE_COMMAND: string,
    GENERAL_MASTER_INIT_COMMAND: string,
    STACKED_MASTER_INIT_COMMAND: string,
    MASTER_AUTOSCALING_GROUP: string,
    TASK_REFRESH_TIMEOUT: string,
    TASK_EXECUTE_LIMIT: string,
    KUBERNETES_VERSION: string,
    LOAD_BALANCER_DNS: string,
    BACKUP_NAMESPACES: string,
    BACKUP_RESOURCES: string,
    DOCKER_VERSION: string,
    S3_BACKUP_BUCKET: string,
    S3_BUCKET_REGION: string,
    S3_BUCKET_NAME: string,
    SQS_QUEUE_URL: string,
    CLUSTER_ID: string,
  },
};

export const handler = async (event: SQSEvent, context: Context): Promise<void> => {
  try {
    const { Event } = JSON.parse(event.Records[0].body);

    if (Event === LifecycleEvent.TestNotification) {
      await deleteQueueTask(event, process.env.SQS_QUEUE_URL);
      return context.succeed(HandlerMessages.TestNotificationHandled);
    }

    const refreshTimeout = parseInt(process.env.TASK_REFRESH_TIMEOUT, 10);
    const executeLimit = parseInt(process.env.TASK_EXECUTE_LIMIT, 10);

    if (!await isInSystemManager(event)) {
      await refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
      return context.fail(HandlerMessages.TaskHandlingDelayed);
    }

    if (await isQueueControlReturn(event, process.env.MASTER_AUTOSCALING_GROUP)) {
      const controlTimeout = Math.ceil(Math.random() * 50);

      await setInstanceTags(event, [
        { Key: TagName.NodeState, Value: NodeState.InitAwaiting },
        { Key: TagName.NodeRole, Value: NodeRole.MaterNode },
      ]);
      await refreshQueueTask(event, process.env.SQS_QUEUE_URL, controlTimeout);
      return context.fail(HandlerMessages.TaskHandlingDelayed);
    }

    if (await isMasterConcurrency(process.env.MASTER_AUTOSCALING_GROUP)) {
      await refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
      return context.fail(HandlerMessages.TaskHandlingDelayed);
    }

    await setInstanceTags(event, [
      { Key: TagName.NodeState, Value: NodeState.InitProcessing },
      { Key: TagName.NodeRole, Value: NodeRole.MaterNode },
    ]);

    await refreshQueueTask(event, process.env.SQS_QUEUE_URL, executeLimit);
    await runCommand(event, process.env.NODE_RUNTIME_INSTALL_COMMAND, {
      KubernetesVersion: [process.env.KUBERNETES_VERSION],
      DockerVersion: [process.env.DOCKER_VERSION],
    });

    if (await isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
      await refreshLifecycle(event);
      await runCommand(event, process.env.STACKED_MASTER_INIT_COMMAND, {
        S3BucketRegion: [process.env.S3_BUCKET_REGION],
        S3BucketName: [process.env.S3_BUCKET_NAME],
        ClusterId: [process.env.CLUSTER_ID],
      });
      await completeLifecycle(event, LifecycleResult.Continue);

    } else {
      const snapshotName = await getLastSnapshot(process.env.S3_BACKUP_BUCKET);
      await completeLifecycle(event, LifecycleResult.Continue);

      if (!snapshotName) {
        await runCommand(event, process.env.GENERAL_MASTER_INIT_COMMAND, {
          S3BucketRegion: [process.env.S3_BUCKET_REGION],
          S3BucketName: [process.env.S3_BUCKET_NAME],
          BalancerDNS: [process.env.LOAD_BALANCER_DNS],
          ClusterId: [process.env.CLUSTER_ID],
        });

      } else {
        await runCommand(event, process.env.GENERAL_MASTER_RESTORE_COMMAND, {
          BackupNamespaces: [process.env.BACKUP_NAMESPACES],
          BackupResources: [process.env.BACKUP_RESOURCES],
          S3BucketRegion: [process.env.S3_BUCKET_REGION],
          S3BucketName: [process.env.S3_BUCKET_NAME],
          ClusterId: [process.env.CLUSTER_ID],
          SnapshotName: [snapshotName],
        });
      }
    }

    await setInstanceTags(event, [
      { Key: TagName.NodeState, Value: NodeState.InitFinished },
      { Key: TagName.NodeRole, Value: NodeRole.MaterNode },
    ]);

    await deleteQueueTask(event, process.env.SQS_QUEUE_URL);
    return context.succeed(HandlerMessages.MasterNodeInitialized);

  } catch (exception) {
    await deleteQueueTask(event, process.env.SQS_QUEUE_URL);
    await completeLifecycle(event, LifecycleResult.Abandon);
    throw exception;
  }
};
