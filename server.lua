require("http.response")
local socket = require("socket")
host = host or "*"
port = port or 80
if arg then
	host = arg[1] or host
	port = arg[2] or port
end
print("Binding to host '" ..host.. "' and port " ..port.. "...")
local s = assert(socket.bind(host, port))
local i, p   = s:getsockname()
assert(i, p)
print("Waiting connection from talker on " .. i .. ":" .. p .. "...")
local connection = s:accept()
print("Connected. Here is the stuff:")
local l, e = connection:receive()
local response = Response:new(200, {['Content-Type'] = "text/plain"}, "OK")
connection:send(response:makeResponseString())
connection:close();
print(e)