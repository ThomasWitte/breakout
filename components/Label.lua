Label = class("Label", Component)

function Label:__init(text, scale)
    self.text = text
    self.scale = scale or 1
end
