require "utils";

local responseCode = {
    [200] = "OK",
    [404] = "Not Found",
    [403] = "Forbidden",
    [405] = "Method Not Allowed",
    [500] = "Internal Server Error",
}

local Header = {
    name = "",
    value = ""
}

Response = {
    HTTPversion = "1.1",
    code = 0,
    headers = {},
    body = "",
}

function Response:new(code, headers, body)
    local res = {};
    setmetatable(res,self);

    self.__index = self;
    self.code = code or 500;
    self.headers = headers or {};
    self.body = body;

    return res;
end

function Response:makeResponseString()
    local response = "HTTP/" .. self.HTTPversion .. " ";
    response = response .. self.code .. " " .. responseCode[self.code] .. "\n";
    for _,header in pairs(self.headers) do
        response = response .. header.name .. ": " .. header.value .. "\n";
    end
    if self.body then
        response = response .. "\n\n" .. self.body .. "\n"
    end
    return response
end
