const Promise = require('bluebird');
const AWS = require('aws-sdk');

const autoScalingGroup = new AWS.AutoScaling();
const systemManager = new AWS.SSM();
const queueService = new AWS.SQS();

AWS.config.setPromisesDependency(Promise);
exports.handler = async (event, context) => {
    const { Event } = JSON.parse(event.Records[0].body);

    try {
        if (Event !== 'autoscaling:TEST_NOTIFICATION') {
            await runCommand(event, process.env.CHANGE_HOSTNAME_COMMAND);
            await runCommand(event, process.env.DOCKER_INSTALL_COMMAND);
            await runCommand(event, process.env.KUBERNETES_INSTALL_COMMAND);
            await completeEvent(event);
        }

        await deleteFromQueue(event);
        return context.succeed();
    } catch (error) {
        return context.fail();
    }
};

async function runCommand(event, commandName) {
    const { EC2InstanceId } = JSON.parse(event.Records[0].body);
    const commandLaunch = await systemManager.sendCommand({
        InstanceIds: [EC2InstanceId],
        DocumentName: commandName
    }).promise();

    const { CommandId, InstanceIds, DocumentName } = commandLaunch.Command;
    let isComplete = commandLaunch.Command.Status === 'Success';

    await new Promise(timeout => setTimeout(timeout, 2000));
    while (!isComplete) {
        const invocation = await systemManager.getCommandInvocation({
            InstanceId: InstanceIds[0],
            CommandId: CommandId,
        }).promise();

        switch (invocation.Status) {
            case 'InProgress':
            case 'Pending':
            case 'Delayed':
                isComplete = false;
                break;

            case 'Success':
                isComplete = true;
                break;

            default:
                throw new Error(`${DocumentName} can not be finished`);
        }

        if (!isComplete) {
            await new Promise(timeout => setTimeout(timeout, 2000));
        }
    }
}

async function completeEvent(event) {
    const messageBody = JSON.parse(event.Records[0].body);
    return autoScalingGroup.completeLifecycleAction({
        AutoScalingGroupName: messageBody.AutoScalingGroupName,
        LifecycleActionToken: messageBody.LifecycleActionToken,
        LifecycleHookName: messageBody.LifecycleHookName,
        InstanceId: messageBody.EC2InstanceId,
        LifecycleActionResult: "CONTINUE"
    }).promise();
}

async function deleteFromQueue(event) {
    const message = event.Records[0];
    return queueService.deleteMessage({
        ReceiptHandle: message.receiptHandle,
        QueueUrl: process.env.SQS_QUEUE_URL,
    }).promise();
}