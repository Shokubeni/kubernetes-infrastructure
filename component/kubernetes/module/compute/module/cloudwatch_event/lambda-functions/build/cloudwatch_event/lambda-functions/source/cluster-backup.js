"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const autoscaling_1 = require("./helper/autoscaling");
const manager_1 = require("./helper/manager");
const manager_2 = require("../../../autoscaling_hook/lambda-functions/source/helper/manager");
exports.handler = async (event, context) => {
    if (await autoscaling_1.isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
        const instanceId = await autoscaling_1.getMasterNodeId(process.env.MASTER_AUTOSCALING_GROUP);
        if (instanceId && await manager_1.isInSystemManager(instanceId)) {
            await await manager_2.runCommand(event, process.env.NODE_RUNTIME_INSTALL_COMMAND, {
                KubernetesVersion: [process.env.KUBERNETES_VERSION],
                DockerVersion: [process.env.DOCKER_VERSION],
            });
        }
    }
};
