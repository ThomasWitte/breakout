RelativePosition = class("RelativePosition")

function RelativePosition:initialize(master, o_x, o_y, o_r)
    self.master = master
    self.o_x = o_x or 0
    self.o_y = o_y or 0
    self.o_r = o_r or 0
end
