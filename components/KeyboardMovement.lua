KeyboardMovement = class("KeyboardMovement", Component)

function KeyboardMovement:__init(l, r, u, d)
    self.left = l
    self.right = r
    self.up = u
    self.down = d
end
