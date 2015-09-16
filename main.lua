require("lovetoys/lovetoys")
require("loader")
require("Scene")

function requireDirectory(basePath)
    for _, item in ipairs(love.filesystem.getDirectoryItems(basePath)) do
        basename = string.match(item, "(.*)%.lua")
        if basename then
            require(basePath .. "/" .. basename)
        end
    end
end

game = {
    win = {
        width = 800,
        height = 600
    },
    
    init = function(self)
        local engine = self.engine
    
        engine:addSystem(AnimationSystem())
        engine:addSystem(GravitationSystem())
        engine:addSystem(PathMovementSystem())
        engine:addSystem(MoveSystem())
        engine:addSystem(CollisionSystem())
        engine:addSystem(KeyboardSystem())
        engine:addSystem(FenceSystem())
        engine:addSystem(RenderSystem())
        engine:addSystem(TimerSystem())
        engine:addSystem(RelativePositionSystem())
    end
}

function love.load()
    requireDirectory("components")
    requireDirectory("systems")
    requireDirectory("events")
    requireDirectory("scenes")

    love.window.setMode(game.win.width, game.win.height)

    game.engine = Engine()
    game.em = EventManager()
    game.loader = Loader(game)

    game:init()

    game.em:fireEvent(LoadScene("Menu"))
end

function love.update(dt)
    game.engine:update(dt)
end

function love.keypressed(key, isrepeat)
    game.em:fireEvent(KeyPressed(key))
end

function love.draw()
    game.engine:draw()
end

function love.quit()
    game.em:fireEvent(ExitGame())
end
