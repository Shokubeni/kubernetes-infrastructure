"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const aws_sdk_1 = require("aws-sdk");
const queueService = new aws_sdk_1.SQS();
async function refreshQueueTask(event, queueUrl, visibilityTimeout) {
    const { receiptHandle } = event.Records[0];
    await queueService
        .changeMessageVisibility({
        VisibilityTimeout: visibilityTimeout,
        ReceiptHandle: receiptHandle,
        QueueUrl: queueUrl,
    })
        .promise();
}
exports.refreshQueueTask = refreshQueueTask;
async function deleteQueueTask(event, queueUrl) {
    const { receiptHandle } = event.Records[0];
    await queueService
        .deleteMessage({
        ReceiptHandle: receiptHandle,
        QueueUrl: queueUrl,
    })
        .promise();
}
exports.deleteQueueTask = deleteQueueTask;
