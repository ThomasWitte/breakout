KeyboardSystem = class("KeyboardSystem", System)

function KeyboardSystem:update(dt)
    for i, v in pairs(self.targets) do
        local movement = v:get("Movement")
        local speed = v:get("KeyboardMovement")
        
        movement.x = 0
        movement.y = 0
        
        if love.keyboard.isDown("left") then
            movement.x = -speed.left
        end
        if love.keyboard.isDown("right") then
            movement.x = speed.right
        end
        if love.keyboard.isDown("up") then
            movement.y = -speed.up
        end
        if love.keyboard.isDown("down") then
            movement.y = speed.down
        end
    end
end

function KeyboardSystem:requires()
    return {"KeyboardMovement", "Movement"}
end
