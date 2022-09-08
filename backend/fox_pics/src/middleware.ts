import { verifyKey } from 'discord-interactions'
import type {Context, Next} from 'hono'

export function VerifySignature(publicKey: (c: Context) => string) {

    return async (c: Context, next: Next) => {
        const signature = c.req.header('X-Signature-Ed25519')
        const timestamp = c.req.header('X-Signature-Timestamp')

        if (!signature || !timestamp) {
            c.res =  c.text('Invalid request signature', 401)
            return
        }

        const body = await c.req.clone().arrayBuffer()
        
        const isValidRequest = verifyKey(
            body, 
            signature,
            timestamp,
            publicKey(c)
        )
        if(!isValidRequest) {
            console.log("Invalid")
            c.res = c.text("Invalid request signature", 401)
            return
        }

        await next()
    }
}