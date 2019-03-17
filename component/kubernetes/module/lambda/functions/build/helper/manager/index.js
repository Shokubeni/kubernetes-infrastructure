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
const aws_sdk_1 = require("aws-sdk");
const types_1 = require("./types");
const systemManager = new aws_sdk_1.SSM();
function runCommand(event, command, params) {
    return __awaiter(this, void 0, void 0, function* () {
        const instanceId = (typeof event === 'object')
            ? JSON.parse(event.Records[0].body).EC2InstanceId
            : event;
        const commandLaunch = yield systemManager
            .sendCommand({
            InstanceIds: [instanceId],
            DocumentName: command,
            Parameters: params,
        })
            .promise();
        const { CommandId, InstanceIds, DocumentName, Status } = commandLaunch.Command;
        let isComplete = (Status === types_1.CommandStatus.Success);
        while (!isComplete) {
            yield new Promise(timeout => setTimeout(timeout, 5000));
            const invocation = yield systemManager
                .getCommandInvocation({
                CommandId,
                InstanceId: InstanceIds[0],
            })
                .promise();
            switch (invocation.Status) {
                case types_1.CommandStatus.InProgress:
                case types_1.CommandStatus.Pending:
                case types_1.CommandStatus.Delayed:
                    isComplete = false;
                    break;
                case types_1.CommandStatus.Success:
                    isComplete = true;
                    break;
                default:
                    console.log(JSON.stringify(invocation));
                    throw new Error(`${DocumentName} can not be finished`);
            }
        }
    });
}
exports.runCommand = runCommand;
function isInSystemManager(event) {
    return __awaiter(this, void 0, void 0, function* () {
        const instanceId = (typeof event === 'object')
            ? JSON.parse(event.Records[0].body).EC2InstanceId
            : event;
        const result = yield systemManager
            .describeInstanceInformation({
            InstanceInformationFilterList: [{
                    valueSet: [instanceId],
                    key: 'InstanceIds',
                }],
        })
            .promise();
        const { InstanceInformationList } = result;
        if (InstanceInformationList) {
            return InstanceInformationList.length > 0;
        }
        return false;
    });
}
exports.isInSystemManager = isInSystemManager;
