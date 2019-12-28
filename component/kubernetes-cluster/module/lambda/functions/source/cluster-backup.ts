import {getMasterNodeId, isMasterNodeExists} from './helper/autoscaling';
import {isInSystemManager, runCommand} from './helper/manager';

declare var process : {
  env: {
    MASTER_AUTOSCALING_GROUP: string,
    ETCD_BACKUP_COMMAND: string,
    CUSTOM_RESOURCES: string,
    BACKUPS_TTL: string,
    CLUSTER_ID: string,
  },
};

export const handler = async (): Promise<void> => {
  if (await isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
    const instanceId = await getMasterNodeId(process.env.MASTER_AUTOSCALING_GROUP);

    if (instanceId && await isInSystemManager(instanceId)) {
      await runCommand(instanceId, process.env.ETCD_BACKUP_COMMAND, {
        CustomResources: [process.env.CUSTOM_RESOURCES],
        BackupsTTL: [process.env.BACKUPS_TTL],
      });
    }
  }
};
