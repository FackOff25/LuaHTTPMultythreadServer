require "listener.server"

host = host or "*"
port = port or 80
if arg then
	host = arg[1] or host
	port = arg[2] or port
end

local server = Server:new()
server:start(host, port);
