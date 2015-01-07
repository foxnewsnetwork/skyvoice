require! {
  express
  http
  "socket.io": socket-io
}

app = express!
http-server = http.Server app
io = socket-io http-server

if "development" is app.get("env")
  console.log "development"
  app.listen "3001"

(socket) <- io.on "connection"
socket.on "sanity", (msg) ->
  io.emit "sanity", { msg: "returning: #{msg}" }

socket.on "offer candidate", (candidate) ->
  socket.broadcast.emit "answer candidate", candidate: candidate

