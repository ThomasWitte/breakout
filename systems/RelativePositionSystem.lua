RelativePositionSystem = class("RelativePositionSystem", System)

function RelativePositionSystem:update(dt)
    for i, v in pairs(self.targets) do
        local position = v:get("Position")
        local rpos = v:get("RelativePosition")
        local mpos = rpos.master:get("Position")
        
        position.x = mpos.x + rpos.o_x * math.cos(mpos.r) - rpos.o_y * math.sin(mpos.r)
        position.y = mpos.y + rpos.o_x * math.sin(mpos.r) + rpos.o_y * math.cos(mpos.r)
        position.r = mpos.r + rpos.o_r
    end
end

function RelativePositionSystem:requires()
    return {"Position", "RelativePosition"}
end
