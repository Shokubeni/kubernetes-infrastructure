import { SQSEvent, Context } from 'aws-lambda';

import { completeLifecycle, isMasterNodeExists, refreshLifecycle, setInstanceTags } from './helper/autoscaling';
import { LifecycleEvent, LifecycleResult, NodeRole, NodeState, TagName } from './helper/autoscaling/types';
import { deleteQueueTask, refreshQueueTask } from './helper/queue';
import { runCommand, isInSystemManager } from './helper/manager';
import { TASK_REFRESH_TIMEOUT } from './constant/timeouts';
import { HandlerMessages } from './constant/messages';

declare var process : {
  env: {
    NODE_RUNTIME_INSTALL_COMMAND: string,
    GENERAL_MASTER_INIT_COMMAND: string,
    STACKED_MASTER_INIT_COMMAND: string,
    MASTER_AUTOSCALING_GROUP: string,
    LOAD_BALANCER_DNS: string
    KUBERNETES_VERSION: string,
    DOCKER_VERSION: string,
    S3_BUCKED_NAME: string,
    SQS_QUEUE_URL: string,
    CLUSTER_ID: string,
  },
};

export const handler = async (event: SQSEvent, context: Context): Promise<void> => {
  const { Event } = JSON.parse(event.Records[0].body);

  if (Event === LifecycleEvent.TestNotification) {
    await deleteQueueTask(event, process.env.SQS_QUEUE_URL);
    return context.succeed(HandlerMessages.TestNotificationHandled);
  }

  if (!await isInSystemManager(event)) {
    await refreshQueueTask(event, process.env.SQS_QUEUE_URL, TASK_REFRESH_TIMEOUT);
    return context.fail(HandlerMessages.TaskHandlingDelayed);
  }

  await deleteQueueTask(event, process.env.SQS_QUEUE_URL);
  await runCommand(event, process.env.NODE_RUNTIME_INSTALL_COMMAND, {
    KubernetesVersion: [process.env.KUBERNETES_VERSION],
    DockerVersion: [process.env.DOCKER_VERSION],
  });

  if (await isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
    await refreshLifecycle(event);
    await runCommand(event, process.env.STACKED_MASTER_INIT_COMMAND, {
      S3BucketName: [process.env.S3_BUCKED_NAME],
    });
    await completeLifecycle(event, LifecycleResult.Continue);

  } else {
    await completeLifecycle(event, LifecycleResult.Continue);
    await runCommand(event, process.env.GENERAL_MASTER_INIT_COMMAND, {
      S3BucketName: [process.env.S3_BUCKED_NAME],
      BalancerDNS: [process.env.LOAD_BALANCER_DNS],
      ClusterId: [process.env.CLUSTER_ID],
    });
  }

  await setInstanceTags(event, [
    { Key: TagName.NodeState, Value: NodeState.NodeInitialized },
    { Key: TagName.NodeRole, Value: NodeRole.MaterNode },
  ]);
  return context.succeed(HandlerMessages.MasterNodeInitialized);
};
