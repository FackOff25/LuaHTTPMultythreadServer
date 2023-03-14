require("http.httpUtils")

---@class Response
Response = {
    HTTPversion = "1.1",
    code = 0,
    headers = {},
    body = "",
}

---@param code number
---@param headers {[string] : string}
---@return Response
function Response:new(code, headers, body)
    local res = {};
    setmetatable(res,self);

    self.__index = self;
    self.code = code or 500;
    self.headers = headers or {};
    self.body = body;

    return res;
end

---Make http response string from the object
---@return string
function Response:makeResponseString()
    local response = "HTTP/" .. self.HTTPversion .. " ";
    response = response .. self.code .. " " .. responseCode[self.code] .. "\n";
    for name, value in pairs(self.headers) do
        response = response .. name .. ": " .. value .. "\n";
    end
    if self.body then
        response = response .. "\n" .. self.body .. "\n";
    end
    return response;
end

---Adds and replace headers
---@param headers {[string]: string}
function Response:setHeaders(headers)
    for name, value in pairs(headers) do
        self.headers[name] = value;
    end
end

function Response:get404(headers)
    return Response:new(404, headers)
end

function Response:get405(headers)
    return Response:new(405, headers)
end
