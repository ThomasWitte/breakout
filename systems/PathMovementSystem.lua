PathMovementSystem = class("PathMovementSystem", System)

function PathMovementSystem:update(dt)
    for i, v in pairs(self.targets) do
        local movement = v:get("Movement")
        local path_m = v:get("PathMovement")
        
        local tgt = path_m.targets[path_m.step]
        local tx = tgt[2]
        local ty = tgt[3]
        local tt = tgt[4]
        
        if path_m.t + dt > tt then
            local ntgt = path_m.targets[path_m.step]
            local ntx = ntgt[2]
            local nty = ntgt[3]
            local ntt = ntgt[4]
        
            local p = (tt-path_m.t) / dt
            movement.x = tx*p/tt + ntx*(1-p)/ntt
            movement.y = ty*p/tt + nty*(1-p)/ntt
            path_m.t = dt - tt + path_m.t
            path_m.step = (path_m.step % (#path_m.targets)) + 1
            
            if path_m.step == 1 and not path_m.cycle then
                movement.x = 0
                movement.y = 0
                v:remove("PathMovement")
            end
        else
            movement.x = tx/tt
            movement.y = ty/tt
            path_m.t = path_m.t + dt
        end
    end
end

function PathMovementSystem:requires()
    return {"PathMovement", "Movement"}
end
