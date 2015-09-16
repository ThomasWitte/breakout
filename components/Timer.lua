Timer = class("Timer", Component)

function Timer:__init(time, callback)
    self.time = time
    self.callback = callback
end
