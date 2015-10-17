Position = class("Position")

function Position:initialize(x, y, r)
    self.x = x
    self.y = y
    self.r = r or 0
end
