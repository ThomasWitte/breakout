Scene = class("Scene")

function Scene:fadeIn(game, effect, time)
    if effect == "PanLR" then
        local fade = Entity(self.root)
        fade:add(Position(game.win.width/2, game.win.height/2))
        fade:add(Drawable({0,0,0}))
        fade:add(Rect(game.win.width, game.win.height))
        fade:add(Movement(game.win.width / time, 0))
        fade:add(Timer(time, function() game.engine:removeEntity(fade) end))
        game.engine:addEntity(fade)
    elseif effect == "Fade" then
        local fade = Entity(self.root)
        fade:add(Position(game.win.width/2, game.win.height/2))
        fade:add(Drawable({0,0,0,255}))
        fade:add(Rect(game.win.width, game.win.height))
        fade:add(ColorChangeAnimation({0,0,0,0}, time))
        fade:add(Timer(time, function() game.engine:removeEntity(fade) end))
        game.engine:addEntity(fade)
    end
end

function Scene:fadeOut(game, effect, time)
    if effect == "PanLR" then
        local fade = Entity(self.root)
        fade:add(Position(-game.win.width/2, game.win.height/2))
        fade:add(Drawable({0,0,0}))
        fade:add(Rect(game.win.width, game.win.height))
        fade:add(Movement(game.win.width / time, 0))
        fade:add(Timer(time, function() game.engine:removeEntity(fade) end))
        game.engine:addEntity(fade)
    elseif effect == "Fade" then
        local fade = Entity(self.root)
        fade:add(Position(game.win.width/2, game.win.height/2))
        fade:add(Drawable({0,0,0,0}))
        fade:add(Rect(game.win.width, game.win.height))
        fade:add(ColorChangeAnimation({0,0,0,255}, time))
        fade:add(Timer(time, function() game.engine:removeEntity(fade) end))
        game.engine:addEntity(fade)
    end
end
