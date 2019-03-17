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
const queueService = new aws_sdk_1.SQS();
function refreshQueueTask(event, queueUrl, visibilityTimeout) {
    return __awaiter(this, void 0, void 0, function* () {
        const { receiptHandle } = event.Records[0];
        yield queueService
            .changeMessageVisibility({
            VisibilityTimeout: visibilityTimeout,
            ReceiptHandle: receiptHandle,
            QueueUrl: queueUrl,
        })
            .promise();
    });
}
exports.refreshQueueTask = refreshQueueTask;
function deleteQueueTask(event, queueUrl) {
    return __awaiter(this, void 0, void 0, function* () {
        const { receiptHandle } = event.Records[0];
        yield queueService
            .deleteMessage({
            ReceiptHandle: receiptHandle,
            QueueUrl: queueUrl,
        })
            .promise();
    });
}
exports.deleteQueueTask = deleteQueueTask;
