require("threadPool.utils");
---@class ThreadPool
ThreadPool = {
    size = 0,
    freeThreads = {},
    workingThreads = {},
}

function ThreadPool:new()
    local effil = require("effil");
    local obj = {};
    setmetatable(obj,self);

    self.__index = self;
    self.size = GetPoolSize();
    for i = 1, self.size do
        local newThread = effil.thread(Routine);
        table.insert(self.freeThreads, newThread);
    end

    return obj;
end

---@param job function
function ThreadPool:work(job)
    local thread = table.remove(self.freeThreads, 1);;
    while thread == nil do
        self:moveFinished();
        thread = table.remove(self.freeThreads, 1);
    end
    local tr = thread(job);
    table.insert(self.workingThreads, {tr, thread});
end

function ThreadPool:moveFinished()
    for idx, item in ipairs(self.workingThreads) do
        local status = item[1]:status();
        if (status ~= "running" and status ~= "paused") then
            local runnerThread = table.remove(self.workingThreads, idx);
            table.insert(self.freeThreads, runnerThread[2]);
        end
    end
end
