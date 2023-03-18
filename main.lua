package.path = package.path .. ";" .. "./lua/share/?.lua"
package.cpath = package.cpath .. ";" .."./lua/lib/?.so"

require("listener.server")

require("configParser");

cfg = MakeConfigTable("./config/luaServer.conf");

host = cfg["Server"]["host"] or "*"
port = cfg["Server"]["port"] or 80
if arg then
	host = arg[1] or host
	port = arg[2] or port
end

local root = cfg["Server"]["serve_folder"] or nil

local server = Server:new(root)
server:start(host, port);

--[[local socket = require("socket-lanes");
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

socket.select(nil, nil, 20);]]

--[[local socket = require("socket-lanes");
require("http.response");

local server = socket.bind("localhost", 8080);
local clientfd, err = server:acceptfd();
local client, err = socket.tcp(clientfd);
local response = Response:new(200, {['Content-Type'] = "text/plait", ['Content-Length'] = 10}, "OK")
client:send(response:makeResponseString());
socket.select(nil, nil, 3)
client:close()
socket.select(nil, nil, 3)]]

--[[local line = "/httptest/space%20in%20name.txt HTTP/1.1";

local url = string.match(line, "[^ ]+");
line = line:gsub(url .. " " .. "HTTP/", '');]]
