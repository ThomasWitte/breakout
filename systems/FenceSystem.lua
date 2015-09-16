FenceSystem = class("FenceSystem", System)

function FenceSystem:update(dt)
    for i, v in pairs(self.targets) do
        local position = v:get("Position")
        local fence = v:get("Fence")
        
        if position.x < fence.x then
            position.x = fence.x
        end
        
        if position.y < fence.y then
            position.y = fence.y
        end
        
        if position.x > fence.x + fence.w then
            position.x = fence.x + fence.w
        end
        
        if position.y > fence.y + fence.h then
            position.y = fence.y + fence.h
        end
    end
end

function FenceSystem:requires()
    return {"Position", "Fence"}
end
