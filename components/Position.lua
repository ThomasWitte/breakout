Position = class("Position", Component)

function Position:__init(x, y, r)
    self.x = x
    self.y = y
    self.r = r or 0
end
