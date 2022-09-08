/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `wrangler dev src/index.ts` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `wrangler publish src/index.ts --name my-worker` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

import { Hono } from "hono"
import { cors } from "hono/cors"
import discord from "./discord"
export interface Env {
	// Example binding to KV. Learn more at https://developers.cloudflare.com/workers/runtime-apis/kv/
	// FOX_VARS: KVNamespace
	Bindings: {
		FOX_VARS: KVNamespace
		DISCORD_PUBLIC_KEY: string
		BOT_TOKEN: string
		AWS_ACCESS_KEY_ID: string
		AWS_SECRET_ACCESS_KEY: string
	}
	//
	// Example binding to Durable Object. Learn more at https://developers.cloudflare.com/workers/runtime-apis/durable-objects/
	// MY_DURABLE_OBJECT: DurableObjectNamespace;
	//
	// Example binding to R2. Learn more at https://developers.cloudflare.com/workers/runtime-apis/r2/
	// MY_BUCKET: R2Bucket;
}
const corsHeader = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,HEAD,POST,OPTIONS',
  'Access-Control-Max-Age': '86400',
}
const app = new Hono<Env>()
const v1 = new Hono<Env>()

v1.use(cors({
	origin: "*",
	allowMethods: ["GET", "HEAD", "POST", "OPTIONS"],
	maxAge: 86400,
}))

v1.route("/discord", discord)

async function getFullFoxList(namespace: KVNamespace): Promise<string[] | null> {
	return await namespace.get("MASTER_FOX_LIST", "json")
}

function getRandomFromList(a: string[], amount=1): string[]  {
	const output = []
	for (let i=0; i<amount; i++) {	
		output.push("https://store.fox.pics/"+a[Math.floor(Math.random() * a.length)])
	}
	return output
}

v1.get("/get-random-foxes", async (c) => {
	const amountParam = c.req.query("amount")
	let amount = 25
	
	if(amountParam != undefined) {	
		const newAmount = parseInt(amountParam)
		amount = Math.min(amount, newAmount)
	}

	if(!c.env) { 
		return c.text("internal server error")
	}

	const foxKeys = await getFullFoxList(c.env.FOX_VARS)
	const randomFoxes = getRandomFromList(foxKeys || [], amount)
	return c.json(randomFoxes)
})

app.route("/v1", v1)

export default app;