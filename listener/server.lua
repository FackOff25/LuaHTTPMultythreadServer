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

        local req = connection:receive();
        local request = getRequest(req);

        if(request.method ~= 'GET' and request.method ~= 'HEAD') then
            SendMethodNotAllowed(connection);
        elseif e ~= "closed" then
            local path = "." .. request.url;

            if isForbidden(path) then
                SendForbidden(connection);
            end

            if isDir(path) then
                if path:sub(-1) ~= "/" then
                    path = path .. "/";
                end
                path = path .. "index.html";
            end
            local f = io.open(path, "rb" );

            if (f ~= nil) then
                SendFile(path, connection, request.method);
            elseif path ~= "." .. request.url then
                SendForbidden(connection);
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

        print("Server listen on: " .. self.host .. ":" .. self.port);
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
