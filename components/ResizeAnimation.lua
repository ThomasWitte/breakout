ResizeAnimation = class("ResizeAnimation", Component)

function ResizeAnimation:__init(scale, t, cb_finished)
    self.cb_finished = cb_finished
    self.t = t
    self.scale = scale
    self.current_scale = 1
end
