MoveSystem = class("MoveSystem", System)

function MoveSystem:update(dt)
    for i, v in pairs(self.targets) do
        local position = v:get("Position")
        local speed = v:get("Movement")
        position.x = position.x + speed.x * dt
        position.y = position.y + speed.y * dt
        position.r = position.r + speed.r * dt
        
        if speed.drall ~= 0 then
            local sx = speed.x * math.cos(speed.drall*dt) - speed.y * math.sin(speed.drall*dt)
            local sy = speed.x * math.sin(speed.drall*dt) + speed.y * math.cos(speed.drall*dt)
            
            speed.x = sx
            speed.y = sy
        end
    end
end

function MoveSystem:requires()
    return {"Position", "Movement"}
end
