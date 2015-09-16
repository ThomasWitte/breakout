TimerSystem = class("TimerSystem", System)

function TimerSystem:update(dt)
    for i, v in pairs(self.targets) do
        local timer = v:get("Timer")
        timer.time = timer.time - dt
        if timer.time <= 0 then
            timer.callback(v)
            v:remove("Timer")
        end
    end
end

function TimerSystem:requires()
    return {"Timer"}
end
