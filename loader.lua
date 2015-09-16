Loader = class("Loader")

function Loader:__init(game)
    game.em:addListener("LoadScene", self, self.loadScene)
    game.em:addListener("ExitGame", self, self.exitGame)
    self.game = game
end

function Loader:loadScene(event)
    if self.scene then
        self.scene:destroy(self.game)
    end

    self.scene = _G[event.scene]()
    self.scene:create(self.game)
end

function Loader:exitGame(event)
    if self.scene then
        self.scene:destroy(self.game)
    end
end
