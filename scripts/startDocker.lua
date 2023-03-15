os.execute("sudo docker rm luaserver");
local path = io.popen("pwd"):read("*a");
path = path:match("(.*/)");
local comand = "sudo docker run -v " .. path .. "httpd.conf:/server/httpd.conf:ro -p 127.0.0.1:8080:80 --name luaserver -t luaserver";
print(comand);
os.execute(comand);