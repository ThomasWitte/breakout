CollisionSystem = class("CollisionSystem", System)

local function inside(vecs, x1, y1)
    local intersection_count = 0

    local x2 = 10000
    local y2 = 10000

    for _, b in ipairs(vecs) do
        local s = ((b.x3-x1)*(b.y3-b.y4) - (b.y3-y1)*(b.x3-b.x4))
                / ((x2-x1)*(b.y3-b.y4) - (y2-y1)*(b.x3-b.x4))

        local t = ((x2-x1)*(b.y3-y1) - (y2-y1)*(b.x3-x1))
                / ((x2-x1)*(b.y3-b.y4) - (y2-y1)*(b.x3-b.x4))

        if s >= 0 and s <= 1 and t >= 0 and t <= 1 then
            intersection_count = intersection_count + 1
        end
    end
    
    return intersection_count % 2 == 1
end

function CollisionSystem:update(dt)
    for i, v in pairs(self.targets.ball) do
        local cb_funcs = {}
    
        local position = v:get("Position")
        local movement = v:get("Movement")
        local circle = v:get("Circle")

        local px = position.x
        local py = position.y
        local mx = movement.x
        local my = movement.y

        for _, box in pairs(self.targets.box) do
            local x1 = position.x - movement.x*dt
            local y1 = position.y - movement.y*dt
            local x2 = position.x
            local y2 = position.y
            
            local box_pos = box:get("Position")
            local box_rect = box:get("Rect")
            
            local a = {x = -box_rect.w/2 - circle.r, y = -box_rect.h/2 - circle.r}
            local b = {x = -box_rect.w/2 - circle.r, y = box_rect.h/2 + circle.r}
            local c = {x = box_rect.w/2 + circle.r, y = box_rect.h/2 + circle.r}
            local d = {x = box_rect.w/2 + circle.r, y = -box_rect.h/2 - circle.r}
            local r = {math.cos(box_pos.r), -math.sin(box_pos.r),
                       math.sin(box_pos.r),  math.cos(box_pos.r)}
            
            local vbox = {
              {x3 = box_pos.x + a.x * r[1] + a.y * r[2], y3 = box_pos.y + a.x * r[3] + a.y * r[4],
               x4 = box_pos.x + b.x * r[1] + b.y * r[2], y4 = box_pos.y + b.x * r[3] + b.y * r[4]},
              {x3 = box_pos.x + b.x * r[1] + b.y * r[2], y3 = box_pos.y + b.x * r[3] + b.y * r[4],
               x4 = box_pos.x + c.x * r[1] + c.y * r[2], y4 = box_pos.y + c.x * r[3] + c.y * r[4]},
              {x3 = box_pos.x + c.x * r[1] + c.y * r[2], y3 = box_pos.y + c.x * r[3] + c.y * r[4],
               x4 = box_pos.x + d.x * r[1] + d.y * r[2], y4 = box_pos.y + d.x * r[3] + d.y * r[4]},
              {x3 = box_pos.x + d.x * r[1] + d.y * r[2], y3 = box_pos.y + d.x * r[3] + d.y * r[4],
               x4 = box_pos.x + a.x * r[1] + a.y * r[2], y4 = box_pos.y + a.x * r[3] + a.y * r[4]},
            }
            
            if inside(vbox, x1, y1) then
                x1 = x1 - movement.x*dt
                y1 = y1 - movement.y*dt
            end
            
            local min_s = 10
            
            -- if the ball somehow gets into a box, make sure it gets out again
            if not inside(vbox, x1, y1) then
                for _, b in ipairs(vbox) do
                    local s = ((b.x3-x1)*(b.y3-b.y4) - (b.y3-y1)*(b.x3-b.x4))
                            / ((x2-x1)*(b.y3-b.y4) - (y2-y1)*(b.x3-b.x4))

                    local t = ((x2-x1)*(b.y3-y1) - (y2-y1)*(b.x3-x1))
                            / ((x2-x1)*(b.y3-b.y4) - (y2-y1)*(b.x3-b.x4))
                    
                    if s < min_s and s > 0 and s < 1 and t > 0 and t < 1 then
                        -- Schnittpunkt
                        local tx = b.x3 + t*(b.x4-b.x3)
                        local ty = b.y3 + t*(b.y4-b.y3)
                        
                        -- Winkel zur Normalen der Boxkante
                        local nx = (b.y4-b.y3)
                        local ny = (b.x3-b.x4)
                        local phi = math.atan2(ny, nx) - math.atan2(movement.y, movement.x)

                        -- neue Ballposition
                        px = tx + (x2-tx) * math.cos(math.pi - 2*phi) + (y2-ty) * math.sin(math.pi - 2*phi)
                        py = ty - (x2-tx) * math.sin(math.pi - 2*phi) + (y2-ty) * math.cos(math.pi - 2*phi)

                        -- neuer Bewegungsvektor
                        mx = movement.x * math.cos(math.pi - 2*phi) + movement.y * math.sin(math.pi - 2*phi)
                        my = - movement.x * math.sin(math.pi - 2*phi) + movement.y * math.cos(math.pi - 2*phi)

                        min_s = s
                        
                        --print(tx, ty, mx, my, px, py)
                    end
                end
            end

            if min_s <= 1 and box:has("OnHit") then
                cb_funcs[#cb_funcs + 1] = box:get("OnHit").func
            end
        end
        
        position.x = px
        position.y = py
        movement.x = mx
        movement.y = my
        
        for _, f in ipairs(cb_funcs) do
            f(v)
        end
    end
end

function CollisionSystem:requires()
    return {ball = {"Position", "Movement", "Circle"},
            box  = {"Position", "Rect", "Solid"}}
end
