Drawable = class("Drawable")

function Drawable:initialize(color)
    self.color = {}
    for i=1,4,1 do
        self.color[i] = color[i] or 255
    end
end
