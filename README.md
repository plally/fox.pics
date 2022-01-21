# fox.pics
A website and api that provides random pictures of foxes

### API
**BaseURL**: https://api.fox.pics/v1/
| Method |Endpoint | Description |
| --- |--------------------| --------------- |
| GET | get-random-foxes?amount=n | Get n random pictures of foxes. Returns a list of urls. n can not be greater than 24 |

### Scripts
* `bin/build` - builds the project 
* `bin/build_cloudflare` - a build script made for cloudflare pages
* `bin/serve` - serve the project locally, for developement purposes.
