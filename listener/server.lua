package.path = package.path .. ";" .. "./socket/share/?.lua"
package.cpath = package.cpath .. ";" .."./socket/lib/?.so"

local socket = require("socket-lanes");
require("http.response");

require("threadPool.threadPool");
require("listener.utils")

Server = {
    host = "localhost",
    port = 80,
    isOn = false,
    connections = {},
    server = nil,
}

function Server:new()
    local serv = {};
    setmetatable(serv,self);

    self.__index = self;

    return serv;
end

local function getHandler(fd)
    local handler = function()
        local socket = require("socket-lanes");
        require("listener.utils");
        
        local connection, e = socket.tcp(fd);
        if e ~= "closed" then
            local f = io.open("test2.png", "rb" );
            if (f ~= nil) then
                SendFile(f, connection);
            else
                SendNotFound(connection);
            end
        end
        connection:close();
    end
    return handler;
end


---@param host string
---@param port number
function Server:start(host, port)
    host = host or "localhost";
        port = port or 80;
        
        local server, e = socket.bind(host, port);
        
        if server == nil then
            io.write("Server start error: " ..e.."\n");
            return nil;
        end

        self.server = server;
        local i, p = self.server:getsockname();
        self.host = i;
        self.port = p;
        self.isOn = true;
        local pool = ThreadPool:new();
        
        while self.isOn do
            self:acceptClient(pool);
            while #self.connections > 0 do
                local conn = table.remove(self.connections);
                local job = getHandler(conn);
                pool:work(job);
            end
        end
end

function Server:stop()
    for _, conn in pairs(self.connections) do
        conn.close();
    end
    self.server:stop();
    self.isOn = false;
end

function Server:acceptClient(pool)
    local conn = self.server:acceptfd();
    if conn then
        table.insert(self.connections, conn);
    end
end
