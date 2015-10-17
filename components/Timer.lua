Timer = class("Timer")

function Timer:initialize(time, callback)
    self.time = time
    self.callback = callback
end
