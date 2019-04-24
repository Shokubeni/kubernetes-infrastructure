import { SQSEvent, Context } from 'aws-lambda';

import { completeLifecycle, isMasterNodeExists, refreshLifecycle, setInstanceTags } from './helper/autoscaling';
import { LifecycleEvent, LifecycleResult, NodeRole, NodeState, TagName } from './helper/autoscaling/types';
import { deleteQueueTask, refreshQueueTask } from './helper/queue';
import { runCommand, isInSystemManager } from './helper/manager';
import { HandlerMessages } from './constant/messages';

declare var process : {
  env: {
    NODE_RUNTIME_INSTALL_COMMAND: string,
    COMMON_WORKER_INIT_COMMAND: string,
    MASTER_AUTOSCALING_GROUP: string,
    TASK_REFRESH_TIMEOUT: string,
    TASK_EXECUTE_LIMIT: string,
    KUBERNETES_VERSION: string,
    DOCKER_VERSION: string,
    S3_BUCKET_REGION: string,
    S3_BUCKED_NAME: string,
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
    if (!await isInSystemManager(event)) {
      await refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
      return context.fail(HandlerMessages.TaskHandlingDelayed);
    }

    if (await isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
      await refreshLifecycle(event);
      await runCommand(event, process.env.NODE_RUNTIME_INSTALL_COMMAND, {
        KubernetesVersion: [process.env.KUBERNETES_VERSION],
        DockerVersion: [process.env.DOCKER_VERSION],
      });

      await runCommand(event, process.env.COMMON_WORKER_INIT_COMMAND, {
        S3BucketRegion: [process.env.S3_BUCKET_REGION],
        S3BucketName: [process.env.S3_BUCKED_NAME],
      });
      await setInstanceTags(event, [
        { Key: TagName.NodeState, Value: NodeState.NodeInitialized },
        { Key: TagName.NodeRole, Value: NodeRole.WorkerNode },
      ]);

      await completeLifecycle(event, LifecycleResult.Continue);
      await deleteQueueTask(event, process.env.SQS_QUEUE_URL);
      return context.succeed(HandlerMessages.WorkerNodeInitialized);
    }

    await refreshQueueTask(event, process.env.SQS_QUEUE_URL, refreshTimeout);
    return context.fail(HandlerMessages.TaskHandlingDelayed);

  } catch (exception) {
    await deleteQueueTask(event, process.env.SQS_QUEUE_URL);
    await completeLifecycle(event, LifecycleResult.Abandon);
    throw exception;
  }
};