import { getMasterNodeId, isMasterNodeExists } from './helper/autoscaling';
import { isInSystemManager, runCommand } from './helper/manager';

declare var process : {
  env: {
    MASTER_AUTOSCALING_GROUP: string,
    ETCD_BACKUP_COMMAND: string,
    S3_BUCKED_NAME: string,
  },
};

export const handler = async (): Promise<void> => {
  if (await isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
    const instanceId = await getMasterNodeId(process.env.MASTER_AUTOSCALING_GROUP);

    if (instanceId && await isInSystemManager(instanceId)) {
      await runCommand(instanceId, process.env.ETCD_BACKUP_COMMAND, {
        S3BucketName: [process.env.S3_BUCKED_NAME],
      });
    }
  }
};
