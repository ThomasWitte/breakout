PathMovement = class("PathMovement")

function PathMovement:initialize(targets, cycle)
    self.targets = targets
    self.cycle = cycle
    
    self.t = 0
    self.step = 1
end
