"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const aws_sdk_1 = require("aws-sdk");
const types_1 = require("./types");
const systemManager = new aws_sdk_1.SSM();
async function runCommand(event, command, params) {
    const instanceId = (typeof event === 'object')
        ? JSON.parse(event.Records[0].body).EC2InstanceId
        : event;
    const commandLaunch = await systemManager
        .sendCommand({
        InstanceIds: [instanceId],
        DocumentName: command,
        Parameters: params,
    })
        .promise();
    const { CommandId, InstanceIds, DocumentName, Status } = commandLaunch.Command;
    let isComplete = (Status === types_1.CommandStatus.Success);
    while (!isComplete) {
        await new Promise(timeout => setTimeout(timeout, 5000));
        const invocation = await systemManager
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
                throw new Error(`${DocumentName} can not be finished`);
        }
    }
}
exports.runCommand = runCommand;
async function isInSystemManager(event) {
    const instanceId = (typeof event === 'object')
        ? JSON.parse(event.Records[0].body).EC2InstanceId
        : event;
    const result = await systemManager
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
}
exports.isInSystemManager = isInSystemManager;
