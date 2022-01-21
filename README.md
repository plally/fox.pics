<div align="center">
    <h1><a href=https://fox.pics>fox.pics</a></h1>
    <i>A website and api that provides random pictures of foxes</i>
</div>

<br>
<br>

### API
**BaseURL**: https://api.fox.pics/v1/
| Method |Endpoint | Description |
| --- |--------------------| --------------- |
| GET | get-random-foxes?amount=n | Get n random pictures of foxes. Returns a list of urls. n can not be greater than 25 |

### Scripts
* `bin/build` - builds the project 
* `bin/build_cloudflare` - a build script made for cloudflare pages
* `bin/serve` - serve the project locally, for developement purposes.
