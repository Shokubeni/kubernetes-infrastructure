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
const manager_1 = require("./helper/manager");
exports.handler = () => __awaiter(this, void 0, void 0, function* () {
    if (yield autoscaling_1.isMasterNodeExists(process.env.MASTER_AUTOSCALING_GROUP)) {
        const instanceId = yield autoscaling_1.getMasterNodeId(process.env.MASTER_AUTOSCALING_GROUP);
        if (instanceId && (yield manager_1.isInSystemManager(instanceId))) {
            yield manager_1.runCommand(instanceId, process.env.ETCD_BACKUP_COMMAND, {
                BackupNamespaces: [process.env.BACKUP_NAMESPACES],
                BackupResources: [process.env.BACKUP_RESOURCES],
                BackupsTTL: [process.env.BACKUPS_TTL],
            });
        }
    }
});
