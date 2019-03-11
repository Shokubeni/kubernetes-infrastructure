"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const autoscaling_1 = require("./helper/autoscaling");
const manager_1 = require("./helper/manager");
exports.handler = async () => {
    if (await autoscaling_1.isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
        const instanceId = await autoscaling_1.getMasterNodeId(process.env.MASTER_AUTOSCALING_GROUP);
        if (instanceId && await manager_1.isInSystemManager(instanceId)) {
            await manager_1.runCommand(instanceId, process.env.ETCD_BACKUP_COMMAND, {
                S3BucketName: [process.env.S3_BUCKED_NAME],
            });
        }
    }
};
