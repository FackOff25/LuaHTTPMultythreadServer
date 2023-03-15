--- returns max pool of threads
---@return number
function GetPoolSize()
    --[[local file = io.open("/proc/sys/kernel/threads-max", "r");
    if (file == nil) then
        io.write("can't get number of threads\n")
        return -1;
    end
    local poolSize = file:read("*number");
    file:close();]]
    if cfg["CPU"]["cpu_limit"] == nil then
        local effil = require("effil");
        local poolSize = effil.hardware_threads();
        return poolSize - 1;
    end

    return cfg["CPU"]["cpu_limit"];
end

---@param job function
function Routine(job)
    job();
end