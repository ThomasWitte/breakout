Drawable = class("Drawable", Component)

function Drawable:__init(color)
    self.color = {}
    for i=1,4,1 do
        self.color[i] = color[i] or 255
    end
end
