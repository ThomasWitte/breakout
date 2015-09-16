GameOver = class("GameOver", Scene)

GameOver.root = Entity()

function GameOver:create_boxtext(game, text, ypos)
    local text_len = string.len(text)
    
    local colors = {{255, 255, 50},
                    {255, 50, 255},
                    {50, 255, 255},
                    {50, 50, 255},
                    {50, 255, 50},
                    {255, 50, 50}}
    
    for i=1,text_len,1 do
        if text:sub(i,i) ~= " " then
            local C = Entity(self.root)
            C:add(Label(text:sub(i,i), 2))
            C:add(Position(100 + (i-1)*(game.win.width-200)/(text_len - 1) - 10, ypos - 13))
            C:add(Drawable({0,0,0}))
            game.engine:addEntity(C)

            local box = Entity(self.root)
            box:add(Rect(50, 50))
            box:add(Position(100 + (i-1)*(game.win.width-200)/(text_len - 1), ypos))
            box:add(Drawable(colors[math.random(#colors)]))
            box:add(Solid())
            box:add(OnHit(function()
                box:add(Movement(0, 0, math.pi))
                box:add(Timer(0.5, function()
                    box:get("Position").r = 0
                    box:remove("Movement")
                end))
                
                local col = colors[math.random(#colors)]
                while col[1] == box:get("Drawable").color[1] and
                      col[2] == box:get("Drawable").color[2] and
                      col[3] == box:get("Drawable").color[3] do
                   col = colors[math.random(#colors)]
                end
            
                box:add(ColorChangeAnimation(col, 0.5))
                box:add(ResizeAnimation(0.5, 0.25,
                function()
                    box:add(ResizeAnimation(2, 0.25, function() end))
                end))
            end))
            game.engine:addEntity(box)
        end
    end
end

function GameOver:create(game)
    local engine = game.engine
    engine:addEntity(self.root)
    
    self:create_boxtext(game, "GAME OVER!", 100)
    self:create_boxtext(game, "ANY KEY TO", game.win.height - 200)
    self:create_boxtext(game, "CONTINUE", game.win.height - 100)
   
    local ball = Entity(self.root)
    ball:add(Circle(10))
    ball:add(Position(300, 350))
    ball:add(Movement(250, 250))
    ball:add(Drawable({100, 255, 100}))
    engine:addEntity(ball)
    
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
    bottom:add(Solid())
    engine:addEntity(bottom)
    
    -- catch keypressed event
    game.em:addListener("KeyPressed", class("KeyPressedListener"), function(_, event)
        self:fadeOut(game, "Fade", 0.5)
        local timer = Entity(self.root)
        timer:add(Timer(0.5, function() game.em:fireEvent(LoadScene("Menu")) end))
        engine:addEntity(timer)
    end)

    self:fadeIn(game, "Fade", 0.5)
end

function GameOver:destroy(game)
    local engine = game.engine
    engine:removeEntity(self.root, true)
    game.em:removeListener("KeyPressed", "KeyPressedListener")
end
