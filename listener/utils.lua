local function fileSize (file)
    local current = file:seek()      -- get current position
    local size = file:seek("end")    -- get file size
    file:seek("set", current)        -- restore position
    return size
end

function SendFile (file, conn)
    local size = fileSize( file );
    local response = Response:new(200, {['Content-Type'] = "image/png", ['Content-Length'] = size})
    conn:send(response:makeResponseString())
    local t = file:read(4*1024);
    while t ~= nil do
        conn:send( t );
        t = file:read(4*1024);
    end
    file:close();
end

function SendNotFound (conn)
    local response = Response:get404();
    conn:send(response:makeResponseString())
end