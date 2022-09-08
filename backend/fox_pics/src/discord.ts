import {client as discordClient } from "./discord/client"
import { APIInteraction, APIChatInputApplicationCommandInteraction, APIInteractionResponse, APIApplicationCommandInteraction, ApplicationCommandType, ApplicationCommandOptionType,  } from "discord-api-types/payloads/v10"
import {InteractionResponseType, InteractionType } from "discord-api-types/payloads/v10"
import { Routes } from "discord-api-types/v10"
import { Hono } from "hono"
import { VerifySignature } from "./middleware"
import type {Env} from "./index"
import { generateApprovedMessage, generateSubmissionMessage } from "./messages/messages"
import {handle as approveFox} from "./components/approveFox";

const app = new Hono<Env>()
app.use("/interaction", VerifySignature((c) => c.env.DISCORD_PUBLIC_KEY))

app.post("/interaction", async (c) => {
    const data = await c.req.json()
    const interaction = data as APIInteraction

    discordClient.setToken(c.env.BOT_TOKEN)
    const resp = await handleInteraction(c.env, c.executionCtx, interaction)
    
    return c.json(resp, 200)
})


async function handleInteraction(env: Env["Bindings"], executionContext: ExecutionContext, interaction: APIInteraction): Promise<APIInteractionResponse | undefined> {
    console.log("Received interaction: ", interaction)
    if(interaction.type == InteractionType.Ping) {
        return {
            type: InteractionResponseType.Pong
        }
    } else if(interaction.type == InteractionType.ApplicationCommand) {
        if(interaction.data.name == "submitfox" || interaction.data.name == "submitfoxurl") {
            return await handleSubmitFox(interaction)
        }
    } else if (interaction.type == InteractionType.MessageComponent) {
        if(interaction.data.custom_id == "approve_fox") {
            return await approveFox(env, interaction)
        } else if(interaction.data.custom_id == "deny_fox") {
            return {
                type: InteractionResponseType.UpdateMessage,
                data: {
                    components: [],
                }
            }
        }
    }
}


async function handleSubmitFox(interaction: APIApplicationCommandInteraction): Promise<APIInteractionResponse | undefined> {
    if(interaction.data.type != ApplicationCommandType.ChatInput) {
        return
    }

    for(const option of interaction.data.options || []) {
        if(option.type == ApplicationCommandOptionType.Attachment) {
           const resolvedAttachment = interaction.data.resolved?.attachments?.[option.value]
           if(!resolvedAttachment) {
               continue
           }
        
            const success = await submitFoxToChannel(resolvedAttachment.url)
            if(!success) {
                return
            } 

            return {
                type: InteractionResponseType.ChannelMessageWithSource,
                data: {
                    flags: 64,
                    content: "submitted fox",
                }
            }
        } else if(option.type == ApplicationCommandOptionType.String) {
            const url = option.value
            const success = await submitFoxToChannel(url)
            if(!success) {
                return
            }

            return {
                type: InteractionResponseType.ChannelMessageWithSource,
                data: {
                    flags: 64,
                    content: "submitted fox",
                }
            }
        }
    }
}

async function submitFoxToChannel(url: string): Promise<boolean> {
    const resp = await discordClient.fetch(Routes.channelMessages("1015848927209201765"), {
        method: "POST",
        body: JSON.stringify(generateSubmissionMessage(url))
    })
    console.log(resp.status)

    if(resp.status == 200) return true

    return false
}

export default app