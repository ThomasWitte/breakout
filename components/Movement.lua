Movement = class("Movement", Component)

function Movement:__init(x, y, r, drall)
    self.x = x
    self.y = y
    self.drall = drall or 0
    self.r = r or 0
end
