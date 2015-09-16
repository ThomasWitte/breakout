GravitationSystem = class("GravitationSystem", System)

function GravitationSystem:update(dt)
    for i, v in pairs(self.targets) do
        local grav = v:get("PointGravitation")
        local mov = v:get("Movement")
        local pos = v:get("Position")
        
        local d_2 = (pos.x-grav.cx)^2 + (pos.y-grav.cy)^2
        local a = grav.f / d_2
        local phi = math.atan2(pos.y-grav.cy, pos.x-grav.cx)
        
        local ax = -a * math.cos(phi)
        local ay = -a * math.sin(phi) 
        
        print(phi, a, d_2, ax, ay)
        
        mov.x = mov.x + ax * dt
        mov.y = mov.y + ay * dt
    end
end

function GravitationSystem:requires()
    return {"PointGravitation", "Movement", "Position"}
end
