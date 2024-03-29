local typesTable = {
    [".html"] = "text/html",
    [".css"] = "text/css",
    [".js"] = "application/javascript",
    [".jpg"] = "image/jpeg",
    [".jpeg"] = "image/jpeg",
    [".png"] = "image/png",
    [".gif"] = "image/gif",
    [".swf"] = "application/x-shockwave-flash",
}

local function fileSize (file)
    local current = file:seek()      -- get current position
    local size = file:seek("end")    -- get file size
    file:seek("set", current)        -- restore position
    return size
end

local function getDateHeader()
    local dateTime = os.date("%a, %d %b %Y %X %Z");
    return dateTime;
end

local function getContentType(extention)
    local type = typesTable[extention] or "application/octet-stream"
    return type;
end

--- func desc
---@param filePath string
---@param conn connection
---@param method? string
function SendFile (filePath, conn, method)
    require("http.response");
    method = method or "GET";

    local file = io.open(filePath, "rb");
    local size = fileSize( file );
    local dateTime = getDateHeader();
    local extention = string.match(filePath, "[.][a-zA-Z]+$");

    local response = Response:new(
        200, 
    {   ["Server"]="LuaServer", 
        ['Date'] = dateTime, 
        ["Connection"] = "close", 
        ['Content-Type'] = getContentType(extention), 
        ['Content-Length'] = size,
    })

    conn:send(response:makeResponseString() .. "\r\n");

    if method == "GET" then
        local t = file:read(4*1024);
        while t ~= nil do
            conn:send( t );
            t = file:read(4*1024);
        end
    end
    
    file:close();
end

function SendForbidden (conn)
    require("http.response");

    local dateTime = getDateHeader();
    local response = Response:get403({["Server"]="LuaServer", ["Date"] = dateTime, ["Connection"] = "close"});

    conn:send(response:makeResponseString())
end

function SendNotFound (conn)
    require("http.response");

    local dateTime = getDateHeader();
    local response = Response:get404({["Server"]="LuaServer", ["Date"] = dateTime, ["Connection"] = "close"});

    conn:send(response:makeResponseString())
end

function SendMethodNotAllowed (conn)
    require("http.response");

    local dateTime = getDateHeader();
    local response = Response:get405({["Server"]="LuaServer", ["Date"] = dateTime, ["Connection"] = "close"});

    conn:send(response:makeResponseString())
end

---@param reqStr string
---@return Request
function getRequest(reqStr)
    require("http.request");
    local request = Request:new(reqStr);
    return request;
end

---@param path string
---@return boolean
function isDir(path)
    local f = io.open(path, "r");
    if f == nil then
        return false;
    end
    local ok, err, code = f:read(1);
    f:close();
    return code == 21;
end

function isForbidden(path)
    local _, comeDownCount = string.gsub(path, "[.][.]/", "");
    local _, comeUpCount = string.gsub(path, "/[^/.]+/", "");
    return comeUpCount < comeDownCount;
end
