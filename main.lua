--[[require "listener.server"

host = host or "*"
port = port or 80
if arg then
	host = arg[1] or host
	port = arg[2] or port
end

local server = Server:new()
server:start(host, port);]]

local socket = require("socket");
local effil = require("effil");
require("threadPool.threadPool");

local function job()
	for i = 1, 5 do
		io.write(i.."\n")
		socket.select(nil, nil, 2)
	end
end	

local pool = ThreadPool:new();
for i = 1, 5 do
	pool:work(job);
end

socket.select(nil, nil, 20);

--[[local effil = require("effil");
local socket = require("socket");

local function job()
	for i = 1, 10 do
		io.write(i.."\n");
		local socket = require("socket");
		socket.select(nil, nil, 1)
	end
end
local pool = {};
local co1 = effil.thread(job);
table.insert(pool, co1);
local co2 = effil.thread(job)
table.insert(pool, co2);
print(co1);
local c1 = table.remove(pool, 1);
print(c1);
print(co2);
local c2 = table.remove(pool, 1);
print(c2);
co1();
co2();

socket.select(nil, nil, 15)]]
