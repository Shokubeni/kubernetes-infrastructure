import { LastModified, ListObjectsRequest } from 'aws-sdk/clients/s3';
import { S3 } from 'aws-sdk';
const bucket = new S3();

export async function getLastSnapshot(bucketName: string): Promise<string|null> {
  const snapshots = await bucket
     .listObjects({
       Bucket: bucketName,
       Prefix: 'snapshots/',
     } as ListObjectsRequest)
     .promise();

  if (snapshots.Contents && (snapshots.Contents.length > 0)) {
    const snapshot = snapshots.Contents
      .sort((first, second) => {
        return (first.LastModified as LastModified).getTime() -
         (second.LastModified as LastModified).getTime();
      })
      .pop();

    if (snapshot) {
      return snapshot.Key || null;
    }
  }

  return null;
}
