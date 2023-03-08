responseCode = {
    [200] = "OK",
    [404] = "Not Found",
    [403] = "Forbidden",
    [405] = "Method Not Allowed",
    [500] = "Internal Server Error",
}

Header = {
    name = "",
    value = "",
}

--- func desc
---@param name string
---@param value string
---@return Header = {name: string, value = string}
function Header:new(name, value)
    local header = {};
    setmetatable(header, self);

    self.__index = self;
    self.name = name;
    self.value = value;

    return header;
    
end
