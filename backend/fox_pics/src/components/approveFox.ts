import { APIInteraction, APIInteractionResponse, InteractionResponseType } from "discord-api-types/v10";
import { uploadFileToBucket } from "../s3";
import { generateApprovedMessage, generatePendingSubmissionMessage} from "../messages/messages";
import { Env } from "../index";
import { client as discordClient } from "../discord/client";
import { Routes } from "discord-api-types/v10";
const defaultErrorResponse: APIInteractionResponse =  {
    type: InteractionResponseType.ChannelMessageWithSource,
    data: {
        flags: 64,
        content: "Error with message structure"
    }
}

const extensions: {[k: string]: string} = {
    "image/png": "png",
    "image/jpeg": "jpg",
    "image/jpg": "jpg",
    "image/gif": "gif",
    "image/webp": "webp"
}

export async function handle(env: Env['Bindings'], interaction: APIInteraction): Promise<APIInteractionResponse> {
    const embed = interaction?.message?.embeds?.[0]
    const url = embed?.image?.proxy_url || embed?.image?.url
    if(!url) {
        return defaultErrorResponse
    }
    const resp = await fetch(url)
    if(resp.status != 200 || !resp.body) {
        return defaultErrorResponse
    }
    const contentType = resp.headers.get("content-type")

    const extension = extensions?.[contentType || '']
    if(!extension) {
        return defaultErrorResponse
    }

    const filename = `${crypto.randomUUID()}.${extension}`
    console.log("Uploading ", filename)
    await uploadFileToBucket(env, "store.fox.pics", filename, await resp.arrayBuffer())
    await postSubmittedFox(`https://store.fox.pics/${filename}`)

    let message = generatePendingSubmissionMessage(embed.image?.url || '')
    return {
        type: InteractionResponseType.UpdateMessage,
        data: message
    }
}

async function postSubmittedFox(url: string): Promise<boolean> {
    const resp = await discordClient.fetch(Routes.channelMessages("1016415567059632309"), {
        method: "POST",
        body: JSON.stringify(generateApprovedMessage(url))
    })

    if(resp.status == 200) return true

    return false
}