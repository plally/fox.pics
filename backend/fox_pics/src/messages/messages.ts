import {ButtonStyle, ComponentType, RESTPostAPIChannelMessageJSONBody } from "discord-api-types/v10"

export function generateApprovedMessage(url: string): RESTPostAPIChannelMessageJSONBody {
    return {
        components: [
        ],
        embeds: [
            {
                "title": "New fox",
                "description": "A new fox has been added to fox.pics",
                "image": {
                    "url": url,
                }
            }
        ]
    }
}


export function generatePendingSubmissionMessage(url: string): RESTPostAPIChannelMessageJSONBody {
    return {
        components: [],
        embeds: [
            {
                "title": "New fox submission is being pending upload",
                "description": "This submission has been approved",
                "image": {
                    "url": url,
                }
            }
        ]
    }
}

export function generateSubmissionMessage(url: string): RESTPostAPIChannelMessageJSONBody {
    return {
        components: [
            {
                type: ComponentType.ActionRow,
                components: [
                    {
                        type: ComponentType.Button,
                        label: "Approve",
                        style: ButtonStyle.Success,
                        custom_id: "approve_fox"
                    },
                    {
                        type: ComponentType.Button,
                        label: "deny",
                        style: ButtonStyle.Danger,
                        custom_id: "deny_fox"
                    }
                ]
            }
        ],
        embeds: [
            {
                "title": "New fox submission",
                "description": "A new fox has been submitted to fox.pics",
                "image": {
                    "url": url,
                }
            }
        ]
    }
}