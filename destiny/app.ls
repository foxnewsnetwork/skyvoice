require! {
  express
  http
  "socket.io": socket-io
  path
  mkdirp
  fs
}

app = express!
http-server = http.Server app
io = socket-io http-server # , origins: "localhost:* localhost:4201"

# app.use (req, res, next) ->
#   res.setHeader('Access-Control-Allow-Origin', "http://localhost:4200")
#   res.setHeader("Access-Control-Allow-Credentials", true)
#   res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE')
#   res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type')
#   next!

# Setup
if "production" is app.get("env")
  folder = path.join __dirname, "tmp", "sockets"
  mkdirp.sync folder
  file = path.join folder, "destiny.sock"
  console.log "production: #{file}"
  http-server.listen file
else
  console.log app.get "env"
  http-server.listen "4201"
## 

# Shutdown
shutdown = ->
  console.log "shutting down"
  fs.unlinkSync file if file?
  process.exit!
process.on 'SIGTERM', shutdown
process.on 'SIGINT', shutdown
process.on 'SIGQUIT', shutdown
##

attemptEmission = (socket) ->
  if socket.presentRoom
    socket.to(socket.presentRoom).emit
  else
    -> socket.emit "from-server:message", "you're not in a room, buddy"

app.get '/', (req, res) ->
  res.sendFile __dirname + '/views/index.jade'

class SuperDuperIOMessage
  _internal-count = 0
  @count = -> _internal-count += 1

(socket) <- io.on "connection"
socket.on "data", (slug) ->
  slug.header._iotimestamp = SuperDuperIOMessage.count!
  if slug.header and slug.header.room
    socket.to(slug.header.room).emit "data", slug
  else
    socket.broadcast.emit "data", slug

socket.on "from-client:candidate", (candidate) ->
  console.log "candidate"
  console.log candidate
  attemptEmission(socket) "from-server:candidate", candidate

socket.on "from-client:offer", (offer) ->
  console.log "offer"
  console.log offer
  attemptEmission(socket) "from-server:offer", offer

socket.on "from-client:answer", (answer) ->
  console.log "answer"
  console.log answer
  attemptEmission(socket) "from-server:answer", answer