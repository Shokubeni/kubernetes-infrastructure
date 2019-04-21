import { InstanceId } from 'aws-sdk/clients/ec2';
import { SQSEvent } from 'aws-lambda';
import { SSM } from 'aws-sdk';
import {
  DescribeInstanceInformationRequest,
  GetCommandInvocationRequest,
  SendCommandRequest,
  Parameters,
  Command,
} from 'aws-sdk/clients/ssm';

import { CommandStatus } from './types';

const systemManager = new SSM();

export async function runCommand(event: SQSEvent|InstanceId, command: string, params: Parameters): Promise<void> {
  const instanceId = (typeof event === 'object')
    ? JSON.parse(event.Records[0].body).EC2InstanceId
    : event;

  const commandLaunch = await systemManager
    .sendCommand({
        InstanceIds: [instanceId],
        DocumentName: command,
        Parameters: params,
    } as SendCommandRequest)
    .promise();

  const { CommandId, InstanceIds, DocumentName, Status } = commandLaunch.Command as Command;
  let isComplete = (Status === CommandStatus.Success);

  while (!isComplete) {
    await new Promise(timeout => setTimeout(timeout, 5000));

    const invocation = await systemManager
      .getCommandInvocation({
        CommandId,
        InstanceId: (InstanceIds as string[])[0],
      } as GetCommandInvocationRequest)
      .promise();

    switch (invocation.Status) {
      case CommandStatus.InProgress:
      case CommandStatus.Pending:
      case CommandStatus.Delayed:
        isComplete = false;
        break;
      case CommandStatus.Success:
        isComplete = true;
        break;
      default:
        console.log(JSON.stringify(invocation));
        throw new Error(`${DocumentName} can not be finished`);
    }
  }
}

export async function isInSystemManager(event: SQSEvent|InstanceId): Promise<boolean> {
  const instanceId = (typeof event === 'object')
    ? JSON.parse(event.Records[0].body).EC2InstanceId
    : event;

  const result = await systemManager
    .describeInstanceInformation({
        InstanceInformationFilterList: [{
            valueSet: [instanceId],
            key: 'InstanceIds',
        }],
    } as DescribeInstanceInformationRequest)
    .promise();

  const { InstanceInformationList } = result;
  if (InstanceInformationList) {
    return InstanceInformationList.length > 0;
  }

  return false;
}
