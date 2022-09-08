class _Client {
    token: string
    constructor() {
        this.token = ''
    }

    setToken(token: string) {
        this.token = token
    }

    fetch(url: string, options: RequestInit): Promise<Response> {
        console.log(this.token.length)
        url = `https://discord.com/api/v8${url}`
        if(!options.headers) {
            options.headers = {
                "authorization": `Bot ${this.token}`,
                "content-type": "application/json"
            }
        } 

        return fetch(url, options)
    }
}

export const client = new _Client()
