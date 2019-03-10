"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const aws_sdk_1 = require("aws-sdk");
const types_1 = require("./types");
const systemManager = new aws_sdk_1.SSM();
async function runCommand(event, command, params) {
    const { EC2InstanceId } = JSON.parse(event.Records[0].body);
    const commandLaunch = await systemManager
        .sendCommand({
        InstanceIds: [EC2InstanceId],
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
                console.log(JSON.stringify(invocation));
                throw new Error(`${DocumentName} can not be finished`);
        }
    }
}
exports.runCommand = runCommand;
async function isInSystemManager(event) {
    const { EC2InstanceId } = JSON.parse(event.Records[0].body);
    const result = await systemManager
        .describeInstanceInformation({
        InstanceInformationFilterList: [{
                valueSet: [EC2InstanceId],
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
