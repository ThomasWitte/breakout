Label = class("Label")

function Label:initialize(text, scale)
    self.text = text
    self.scale = scale or 1
end
