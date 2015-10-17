ColorChangeAnimation = class("ColorChangeAnimation")

function ColorChangeAnimation:initialize(target_color, t)
    self.t = t
    self.cur_t = 0
    self.target_color = {}
    
    for i=1,4,1 do
        self.target_color[i] = target_color[i] or 255
    end
end
