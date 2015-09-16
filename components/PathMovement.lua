PathMovement = class("PathMovement", Component)

function PathMovement:__init(targets, cycle)
    self.targets = targets
    self.cycle = cycle
    
    self.t = 0
    self.step = 1
end
