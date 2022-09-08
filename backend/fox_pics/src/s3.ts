import {AwsClient} from 'aws4fetch';
import type {Env} from './index'


export async function uploadFileToBucket(env: Env['Bindings'], bucket: string, filename: string, body: ArrayBuffer) {
    console.log(body.byteLength)
    const url = `https://s3.us-east-2.amazonaws.com/${bucket}/`
    const aws = new AwsClient({
        accessKeyId: env.AWS_ACCESS_KEY_ID,
        secretAccessKey: env.AWS_SECRET_ACCESS_KEY,
        region: 'us-east-2'
    });

    const res = await aws.fetch(url + filename, {
        method: 'PUT',
        body: body,
    })
    console.log( res.status)
    console.log(await res.text())
}