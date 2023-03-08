Response = {
    HTTPversion = "1.1",
    code = 0,
    headers = {},
}

function Response:new(code, headers)
    local res = {};
    setmetatable(res,self);

    self.__index = self;
    self.code = code or 500;
    self.headers = headers or {};

    return res;
end

function Response:makeResponseString()
    local response = "HTTP/" .. self.HTTPversion .. " ";
    response = response .. self.code .. " " .. responseCode[self.code] .. "\n";
    for _,header in pairs(self.headers) do
        response = response .. header.name .. ": " .. header.value .. "\n";
    end
    return response;
end

function Response:setHeaders(headers)
    for num, item in ipairs(headers) do
        self.headers[item.name] = item.value;
    end     
end
