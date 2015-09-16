AnimationSystem = class("AnimationSystem", System)

function AnimationSystem:update(dt)
    for i, v in pairs(self.targets.resize) do
        local anim = v:get("ResizeAnimation")
        
        if anim.t > 0 then
            local p = dt / anim.t
            if p > 1 then p = 1 end
            local new_scale = anim.current_scale + (anim.scale - anim.current_scale) * p
    
            if v:has("Rect") then
                local rect = v:get("Rect")

                rect.w = rect.w * new_scale / anim.current_scale
                rect.h = rect.h * new_scale / anim.current_scale
            end

            if v:has("Label") then
                local label = v:get("Label")

                label.scale = new_scale
            end
        
            anim.current_scale = new_scale
            anim.t = anim.t - dt
        else
            v:remove("ResizeAnimation")
            anim.cb_finished(v)
        end
    end
    
    for i, v in pairs(self.targets.color) do
        local anim = v:get("ColorChangeAnimation")
        local draw = v:get("Drawable")
        
        if anim.cur_t < anim.t then
            anim.orig_color = anim.orig_color or draw.color
            for i=1,4,1 do
                draw.color[i] = anim.orig_color[i] + anim.cur_t/anim.t * (anim.target_color[i] - anim.orig_color[i])
            end
            anim.cur_t = anim.cur_t + dt
        else
            draw.color = anim.target_color
            v:remove("ColorChangeAnimation")
        end
    end
end

function AnimationSystem:requires()
    return {resize = {"ResizeAnimation"},
            color = {"ColorChangeAnimation", "Drawable"}}
end
