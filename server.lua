local port = arg[1] or "80"
while true do
    local handle = assert(io.popen("cat index.http | nc -l " .. port))
    handle:flush()
    local output = handle:lines()
    for el in output do
        print(el)
    end
    handle:close()
end