local effil = require("effil");
---@class ThreadPool
ThreadPool = {
    size = 0,
    freeThreads = {},
}

---@param pool ThreadPool
---@param job function
local routine = function(job)
    --local effil = require("effil");
    print(job)
    --job();
    --table.insert(pool.freeThreads, effil.thread(routine));
end

function ThreadPool:new()
    local effil = require("effil");
    local obj = {};
    setmetatable(obj,self);

    self.__index = self;
    self.size = getPoolSize();
    for i = 1, self.size do
        local newThread = effil.thread(routine);
        table.insert(self.freeThreads, newThread);
    end

    return obj;
end

---@param job function
function ThreadPool:work()
    local thread = table.remove(self.freeThreads, 1);
    thread();
end

--- returns max pool of threads
---@param size number
function getPoolSize()
    local file = io.open("/proc/sys/kernel/threads-max", "r");
    local poolSize = file:read("*number");
    file:close();
    return poolSize / 2;
end
