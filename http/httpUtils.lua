responseCode = {
    [200] = "OK",
    [404] = "Not Found",
    [403] = "Forbidden",
    [405] = "Method Not Allowed",
    [500] = "Internal Server Error",
}
---@alias Header {name: string, value: string}
Header = {
    name = "",
    value = "",
}

--- func desc
---@param name string
---@param value string
---@return Header
function Header:new(name, value)
    local header = {};
    setmetatable(header, self);

    self.__index = self;
    self.name = name;
    self.value = value;

    return header;
    
end
