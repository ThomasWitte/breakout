RenderSystem = class("RenderSystem", System)

function RenderSystem:draw()
    for i, v in pairs(self.targets.circle) do
        local position = v:get("Position")
        local circle = v:get("Circle")
        love.graphics.setColor(v:get("Drawable").color)
        love.graphics.circle("fill", position.x, position.y, circle.r, 100)
    end

    for i, v in pairs(self.targets.rect) do
        local position = v:get("Position")
        local rect = v:get("Rect")
        love.graphics.setColor(v:get("Drawable").color)
        love.graphics.push()
        love.graphics.translate(position.x, position.y)
        love.graphics.rotate(position.r)
        love.graphics.rectangle("fill", -rect.w/2, -rect.h/2, rect.w, rect.h)
        love.graphics.pop()
    end

    for i, v in pairs(self.targets.label) do
        local position = v:get("Position")
        local label = v:get("Label")
        love.graphics.setColor(v:get("Drawable").color)
        love.graphics.print(label.text, position.x, position.y, position.r, label.scale)
    end
end

function RenderSystem:requires()
    return {circle = {"Position", "Circle", "Drawable"},
            rect   = {"Position", "Rect", "Drawable"},
            label  = {"Position", "Label", "Drawable"}}
end
