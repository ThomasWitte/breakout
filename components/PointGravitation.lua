PointGravitation = class("PointGravitation", Component)

function PointGravitation:__init(cx, cy, f)
    self.cx = cx
    self.cy = cy
    self.f = f
end
