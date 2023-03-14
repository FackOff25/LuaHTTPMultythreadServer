require "listener.server"

host = host or "*"
port = port or 80
if arg then
	host = arg[1] or host
	port = arg[2] or port
end

local server = Server:new()
server:start(host, port);

--[[local socket = require("socket");
local effil = require("effil");
require("threadPool.threadPool");

local function job()
	local socket = require("socket");
	for i = 1, 3 do
		io.write(i.."\n")
		socket.select(nil, nil, 1)
	end
end	

local pool = ThreadPool:new();
for i = 1, 10 do
	pool:work(job);
end

socket.select(nil, nil, 20);
]]
