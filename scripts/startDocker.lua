-- Script for starting LuaServer in built Docker container
os.execute("sudo docker rm luaserver");
local path = io.popen("pwd"):read("*a");
path = path:match("(.*/)");
local comand = "sudo docker run -v " .. path .. "config/luaServer.conf:/server/config/luaServer.conf:ro -p 127.0.0.1:80:80 --name luaserver -t luaserver";
print(comand);
os.execute(comand);