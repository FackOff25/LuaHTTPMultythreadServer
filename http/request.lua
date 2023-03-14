require("http.httpUtils");

---@class Request
Request = {
    method = "",
    url = "",
    HTTPversion = "1.1",
    headers = {},
    body = "",
}

---@param str string
---@return string[]
local function stringToLines(str)
    local lines = {};
    for s in str:gmatch("[^\r\n]*") do
        table.insert(lines, s)
    end
    return lines
end

local hex_to_char = function(x)
    return string.char(tonumber(x, 16))
end
  
local unescape = function(url)
  return url:gsub("%%(%x%x)", hex_to_char)
end
  

---@param str string
---@return string method, string url, string version
local function parseRequestFirstLine(str)
    local line = str;

    local method = string.match(line, "[A-Z]+");
    line = line:gsub(method .. " ", '');

    local url = string.match(line, "[^ ]+");
    local newurl = unescape(url);
    unescape(line);
    while url ~= newurl do
        url = newurl;
        newurl = unescape(url);
        unescape(line);
    end
    line = line:gsub(url .. " " .. "HTTP/", '');

    local version = string.match(line, "[0-9.]+");
    
    url = string.match(url, "[^?]+");

    if (method == nil or url == nil or version == nil) then
        return nil;
    else
        return method, url, version;
    end
end

---@param str string
---@return Header
local function parseHeader(str)
    local line = str;

    local name = string.match(line, "[^ :]+");
    local value = string.match(line, ": [^ ]+");
    value = value:gsub(": ", '');

    if (name == nil or value == nil) then
        return nil;
    else
        return Header:new(name, value);
    end
end

---@param requestString string
---@return Request
function Request:new(requestString)
    local lines = stringToLines(requestString);
    local res = {};
    setmetatable(res, self);
    self.__index = self;

    self.method, self.url, self.HTTPversion = parseRequestFirstLine(lines[1])
    table.remove(lines, 1);

    local header;
    local bodyLineIdx = 1;
    for i, line in ipairs(lines) do
        if line ~= "" then
            header = parseHeader(line);
            self.headers[header.name] = header.value;
        else
            bodyLineIdx = i;
            break;
        end
    end

    while lines[bodyLineIdx] == "" do
        bodyLineIdx = bodyLineIdx + 1;
    end

    while lines[bodyLineIdx] ~= "" and lines[bodyLineIdx] ~= nil do
        self.body = self.body .. lines[bodyLineIdx];
        bodyLineIdx = bodyLineIdx + 1;
    end
    
    return res;
end

--- @return {name: string, value: string}
function Request:getHeaders()
    local headers = {};
    for name, value in pairs(self.headers) do
        headers[name] = value;
    end
    return headers;
end
