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

function SendFile (file, conn)
    require("http.response");
    local size = fileSize( file );
    local dateTime = getDateHeader();
    local response = Response:new(
        200, 
    {   ["Server"]="LuaServer", 
        ['Date'] = dateTime, 
        ["Connection"] = "close", 
        ['Content-Type'] = "image/png", 
        ['Content-Length'] = size, }
)
    conn:send(response:makeResponseString())
    local t = file:read(4*1024);
    while t ~= nil do
        conn:send( t );
        t = file:read(4*1024);
    end
    file:close();
end

function SendNotFound (conn)
    require("http.response");
    local dateTime = getDateHeader();
    local response = Response:get404({["Server"]="LuaServer", ["Date"] = dateTime, ["Connection"] = "close"});
    conn:send(response:makeResponseString())
end