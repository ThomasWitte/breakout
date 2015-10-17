ResizeAnimation = class("ResizeAnimation")

function ResizeAnimation:initialize(scale, t, cb_finished)
    self.cb_finished = cb_finished
    self.t = t
    self.scale = scale
    self.current_scale = 1
end
