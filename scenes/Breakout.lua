Breakout = class("Breakout", Scene)

Breakout.root = Entity()

function Breakout:create(game)
    local engine = game.engine
    engine:addEntity(self.root)

    local ball = Entity(self.root)
    ball:add(Circle(10))
    ball:add(Position(300, 450))
--    ball:add(Movement(250, 250, 0, 1))
    ball:add(Movement(250, 250))
--    ball:add(PointGravitation(game.win.width/2, game.win.height/2, 10000000))
    ball:add(Drawable({100, 255, 100}))
    engine:addEntity(ball)

    for i=0, 9, 1 do
        for j=0, 13, 1 do
            local off = i % 2 == 0 and 50 or -50
        
            local box = Entity(self.root)
            box:add(Position(game.win.width/2 - 325 + 50 * j - off/2, 65 + 25 * i))
            box:add(Movement(0,0))
            box:add(PathMovement({{"lin", off, 0, 1}, {"lin", -off, 0, 1}}, true))
            box:add(Rect(49, 24))
            box:add(Drawable({255, 100, 100}))
            box:add(OnHit(function() game.em:fireEvent(BoxHit(box)) end))
            box:add(Value(10))
            box:add(Solid())
            engine:addEntity(box)
        end
    end
    
--[[    local grav_box = Entity()
    grav_box:add(Position(game.win.width/2, 150, math.pi/4))
    grav_box:add(Movement(0, 0, 1))
    grav_box:add(Rect(250, 250))
    grav_box:add(Drawable({100, 100, 255}))
    grav_box:add(Value(100))
    grav_box:add(Solid())
    engine:addEntity(grav_box)]]

--[[    local grav_box = Entity()
    grav_box:add(Position(game.win.width/2, 150))
    grav_box:add(Movement(100, 0))
    grav_box:add(PointGravitation(game.win.width/2, 100, 500000))
    grav_box:add(Rect(25, 25))
    grav_box:add(Drawable({100, 100, 255}))
    grav_box:add(OnHit(function() game.em:fireEvent(BoxHit(grav_box)) end))
    grav_box:add(Value(100))
    grav_box:add(Solid())
    engine:addEntity(grav_box)]]
    
    -- add boxes to limit the game area
    local upper = Entity(self.root)
    upper:add(Position(game.win.width/2, -25))
    upper:add(Rect(game.win.width, 50))
    upper:add(Solid())
    engine:addEntity(upper)

    local left = Entity(self.root)
    left:add(Position(-25, game.win.height/2))
    left:add(Rect(50, game.win.height))
    left:add(Solid())
    engine:addEntity(left)

    local right = Entity(self.root)
    right:add(Position(game.win.width+25, game.win.height/2))
    right:add(Rect(50, game.win.height))
    right:add(Solid())
    engine:addEntity(right)

    local bottom = Entity(self.root)
    bottom:add(Position(game.win.width/2, game.win.height+25))
    bottom:add(Rect(game.win.width, 50))
    bottom:add(OnHit(function(ball) game.em:fireEvent(LifeLost(ball)) end))
    bottom:add(Solid())
    engine:addEntity(bottom)

    -- paddle
    local paddle = Entity(self.root)
    paddle:add(Position(game.win.width/2, game.win.height - 25))
    paddle:add(Movement(0, 0, 0))
    paddle:add(Rect(150, 20))
    paddle:add(Drawable({100, 100, 255}))
    paddle:add(KeyboardMovement(400, 400, 0, 0))
    paddle:add(Solid())
    paddle:add(Fence(75, game.win.height - 25, game.win.width - 150, 0))
    engine:addEntity(paddle)
    
    -- point and life counter
    local points_label = Entity(self.root)
    points_label:add(Position(20, 15))
    points_label:add(Label("Punkte:"))
    points_label:add(Drawable({255, 255, 255}))
    engine:addEntity(points_label)
    
    local points_counter = Entity(self.root)
    points_counter:add(Position(100, 15))
    points_counter:add(Label("0"))
    points_counter:add(Drawable({255, 255, 255}))
    engine:addEntity(points_counter)
    
    local life_label = Entity(self.root)
    life_label:add(Position(20, 30))
    life_label:add(Label("Bälle:"))
    life_label:add(Drawable({255, 255, 255}))
    engine:addEntity(life_label)

    local life_counter = Entity(self.root)
    life_counter:add(Position(100, 30))
    life_counter:add(Label("5"))
    life_counter:add(Drawable({255, 255, 255}))
    engine:addEntity(life_counter)

    local active_balls = 1

    -- catch event if bottom box is hit to update lives
    game.em:addListener("LifeLost", class("LifeLostListener"), function(_, event)
        engine:removeEntity(event.ball)
        active_balls = active_balls - 1
        if active_balls == 0 and tonumber(life_counter:get("Label").text) == 0 then
            self:fadeOut(game, "Fade", 0.5)
            local timer = Entity(self.root)
            timer:add(Timer(0.5, function() game.em:fireEvent(LoadScene("GameOver")) end))
            engine:addEntity(timer)
        end
    end)
    
    -- catch event if a fragile box is hit to update points
    game.em:addListener("BoxHit", class("BoxHitListener"), function(_, event)
        local value = event.box:has("Value") and event.box:get("Value").value or 0
        points_counter:get("Label").text = 
            tonumber(points_counter:get("Label").text) + 10

        event.box:add(ResizeAnimation(0, 0.1,
            function() engine:removeEntity(event.box) end))
        event.box:remove("Solid")
        
        local points = Entity(self.root)
        local pos = event.box:get("Position")
        points:add(Position(pos.x, pos.y))
        points:add(Movement(0, -400))
        points:add(Label(value, 1.5))
        points:add(Drawable({0, 255, 0}))
        points:add(Timer(0.5, function(o) engine:removeEntity(o) end))
        points:add(ResizeAnimation(3, 0.5))
        --add lifetime, fading
        engine:addEntity(points)
    end)
    
    -- catch keypressed event
    game.em:addListener("KeyPressed", class("KeyPressedListener"), function(_, event)
        local num_balls = tonumber(life_counter:get("Label").text)
        if num_balls > 0 and (event.key == " " or event.key == "space") then
            life_counter:get("Label").text = num_balls - 1
            local ball = Entity(self.root)
            ball:add(Circle(10))
            ball:add(Position(300, 450))
            ball:add(Movement(250, 250))
            ball:add(Drawable({100, 255, 100}))
            engine:addEntity(ball)
            active_balls = active_balls + 1
        end
    end)

    game.em:addListener("KeyPressed", class("ESCPressedListener"), function(_, event)
        if event.key == "escape" then
            self:fadeOut(game, "Fade", 0.5)
            local timer = Entity(self.root)
            timer:add(Timer(0.5, function() game.em:fireEvent(LoadScene("Menu")) end))
            engine:addEntity(timer)
        end
    end)

    self:fadeIn(game, "Fade", 0.5)
end

function Breakout:destroy(game)
    local engine = game.engine
    engine:removeEntity(self.root, true)
    game.em:removeListener("LifeLost", "LifeLostListener")
    game.em:removeListener("BoxHit", "BoxHitListener")
    game.em:removeListener("KeyPressed", "KeyPressedListener")
    game.em:removeListener("KeyPressed", "ESCPressedListener")
end
