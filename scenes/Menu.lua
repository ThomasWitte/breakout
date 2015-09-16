Menu = class("Menu", Scene)

Menu.root = Entity()

local move_t = 0.25

local menu_items = {
    {label = "Breakout", action = function() game.em:fireEvent(LoadScene("Breakout")) end},
    {label = "Quit", action = function() love.event.quit() end}
}

function Menu:prepareEntry(game, menu_position)
    local item_bg = Entity(self.root)
    item_bg:add(Rect(400, 300))
    item_bg:add(Drawable({150, 255, 255}))
    item_bg:add(Position(0,0))
    game.engine:addEntity(item_bg)
    
    local item_label = Entity(item_bg)
    item_label:add(Position(0,0))
    item_label:add(RelativePosition(item_bg, -190, -140))
    item_label:add(Label(menu_items[menu_position].label, 1.5))
    item_label:add(Drawable({0,0,0}))
    game.engine:addEntity(item_label)
    
    return item_bg
end

function Menu:createArrow(game, size, color)
    local master = Entity(self.root)
    master:add(Position(0,0))
    game.engine:addEntity(master)

    local r1 = Entity(master)
    r1:add(Position(0,0))
    r1:add(RelativePosition(master, 0, -size/4, -math.pi/4))
    r1:add(Rect(size/2 * math.sqrt(2) + size/5, size/5))
    r1:add(Drawable(color))
    game.engine:addEntity(r1)
    
    local r2 = Entity(master)
    r2:add(Position(0,0))
    r2:add(RelativePosition(master, 0, size/4, math.pi/4))
    r2:add(Rect(size/2 * math.sqrt(2) + size/5, size/5))
    r2:add(Drawable(color))
    game.engine:addEntity(r2)
    
    return master
end

function Menu:create(game)
    local engine = game.engine
    engine:addEntity(self.root)
    
    local menu_position = 1
    
    local item = self:prepareEntry(game, menu_position)
    item:set(Position(game.win.width/2, game.win.height/2))
    
    local arrow_left = self:createArrow(game, 100, {255, 100, 100})
    arrow_left:set(Position(game.win.width/6, game.win.height/2))
    
    local arrow_right = self:createArrow(game, 100, {255, 100, 100})
    arrow_right:set(Position(5*game.win.width/6, game.win.height/2, math.pi))
    
    game.em:addListener("KeyPressed", class("MenuDirectionListener"), function(_, event)
        if event.key == "left" then
            local old_item = item
            item:add(Movement(0,0))
            item:add(PathMovement({{"lin", game.win.width, 0, move_t}}, false))
            item:add(Timer(move_t, function()
                engine:removeEntity(old_item, true)
                item:set(Position(game.win.width/2, game.win.height/2))
            end))

            menu_position = (menu_position-2) % #menu_items + 1

            item = self:prepareEntry(game, menu_position)
            item:set(Position(-game.win.width*0.5, game.win.height/2))
            item:add(Movement(0,0))
            item:add(PathMovement({{"lin", game.win.width, 0, move_t}}, false))
            local arrow_left = self:createArrow(game, 115, {255, 180, 100})
            arrow_left:set(Position(game.win.width/6+2, game.win.height/2))
            arrow_left:add(Timer(move_t, function() engine:removeEntity(arrow_left, true) end))
        elseif event.key == "right" then
            local old_item = item
            item:add(Movement(0,0))
            item:add(PathMovement({{"lin", -game.win.width, 0, move_t}}, false))
            item:add(Timer(move_t, function()
                engine:removeEntity(old_item, true)
                item:set(Position(game.win.width/2, game.win.height/2))
            end))

            menu_position = menu_position % #menu_items + 1

            item = self:prepareEntry(game, menu_position)
            item:set(Position(game.win.width*1.5, game.win.height/2))
            item:add(Movement(0,0))
            item:add(PathMovement({{"lin", -game.win.width, 0, move_t}}, false))
            local arrow_right = self:createArrow(game, 115, {255, 180, 100})
            arrow_right:set(Position(5*game.win.width/6-2, game.win.height/2, math.pi))
            arrow_right:add(Timer(move_t, function() engine:removeEntity(arrow_right, true) end))
        elseif event.key == "escape" then
            self:fadeOut(game, "Fade", 0.5)
            local timer = Entity(self.root)
            timer:add(Timer(0.45, function() love.event.quit() end))
            engine:addEntity(timer)
        end
    end)
    
    game.em:addListener("KeyPressed", class("MenuSelectionListener"), function(_, event)
        if event.key == "return" then
            self:fadeOut(game, "Fade", 0.5)
            local timer = Entity(self.root)
            timer:add(Timer(0.45, menu_items[menu_position].action))
            engine:addEntity(timer)
            
            item:set(Movement(0, 0, 10))
        end
    end)
    self:fadeIn(game, "Fade", 0.5)
end

function Menu:destroy(game)
    local engine = game.engine
    engine:removeEntity(self.root, true)
    game.em:removeListener("KeyPressed", "MenuSelectionListener")
    game.em:removeListener("KeyPressed", "MenuDirectionListener")
end
