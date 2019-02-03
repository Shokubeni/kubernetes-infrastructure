const Promise = require('bluebird');
const AWS = require('aws-sdk');

AWS.config.setPromisesDependency(Promise);
const autoscaling = new AWS.AutoScaling();
const ssm = new AWS.SSM();
const sqs = new AWS.SQS();

exports.handler = async (event, context) => {
    const eventType = JSON.parse(event.Records[0].body).Event;

    try {
        if (eventType === 'autoscaling:TEST_NOTIFICATION') {
            await deleteMessageFromQueue(event);

        } else {
            await runSystemManagerCommands(event);
            await deleteMessageFromQueue(event);
            await completeLifecycleEvent(event);
        }

        context.succeed()
    } catch (error) {
        context.fail();
    }
};

async function runSystemManagerCommands(event) {
    const messageBody = JSON.parse(event.Records[0].body);
    const dockerInstall = await ssm
        .sendCommand({
            DocumentName: process.env.DOCKER_INSTALL_COMMAND,
            InstanceIds: [ messageBody.EC2InstanceId ]
        })
        .promise();

    return new Promise(async (resolve, reject) => {
        const { CommandId, InstanceIds } = dockerInstall.Command;
        let isComplete = dockerInstall.Command.Status === 'Success';

        while (!isComplete) {
            await new Promise(timeout => setTimeout(timeout, 5000));
            const invocation = await ssm
                .getCommandInvocation({
                    InstanceId: InstanceIds[0],
                    CommandId: CommandId,
                })
                .promise();

            switch (invocation.Status) {
                case 'Pending':
                case 'InProgress':
                case 'Delayed':
                    isComplete = false;
                    break;

                case 'Success':
                    isComplete = true;
                    resolve(invocation);
                    break;

                default:
                    reject(new Error(`Docker can't be installed`));
            }

            await new Promise(timeout => setTimeout(timeout, 10000));
        }
    });
}

async function completeLifecycleEvent(event) {
    const messageBody = JSON.parse(event.Records[0].body);
    return autoscaling
        .completeLifecycleAction({
            AutoScalingGroupName: messageBody.AutoScalingGroupName,
            LifecycleActionToken: messageBody.LifecycleActionToken,
            LifecycleHookName: messageBody.LifecycleHookName,
            InstanceId: messageBody.EC2InstanceId,
            LifecycleActionResult: "CONTINUE"
        })
        .promise();
}

async function deleteMessageFromQueue(event) {
    const message = event.Records[0];
    return sqs
        .deleteMessage({
            ReceiptHandle: message.receiptHandle,
            QueueUrl: process.env.SQS_QUEUE_URL,
        })
        .promise();
}