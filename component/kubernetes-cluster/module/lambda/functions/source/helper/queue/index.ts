import { ChangeMessageVisibilityRequest, DeleteMessageRequest } from 'aws-sdk/clients/sqs';
import { SQSEvent } from 'aws-lambda';
import { SQS } from 'aws-sdk';

const queueService = new SQS();

export async function refreshQueueTask(event: SQSEvent, queueUrl: string, visibilityTimeout: number): Promise<void> {
  const { receiptHandle } = event.Records[0];
  await queueService
    .changeMessageVisibility({
      VisibilityTimeout: visibilityTimeout,
      ReceiptHandle: receiptHandle,
      QueueUrl: queueUrl,
    } as ChangeMessageVisibilityRequest)
    .promise();
}

export async function deleteQueueTask(event: SQSEvent, queueUrl: string): Promise<void> {
  const { receiptHandle } = event.Records[0];
  await queueService
    .deleteMessage({
      ReceiptHandle: receiptHandle,
      QueueUrl: queueUrl,
    } as DeleteMessageRequest)
    .promise();
}
