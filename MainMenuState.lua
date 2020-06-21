
local pg = require('PiroGame/PiroGame');
local gs = require('GameState');
local mms = pg.class('MainMenuState', gs);

function mms.testscore(button)
    button.gameState.game.currentScore = { name = 'Test level', time = 1010101, points = 1234 };
    button.gameState.game:switchState('SaveScoreState');
end

function mms:initialize(game)
    gs.initialize(self, game);
    self:resize(love.window.getMode());
end

function mms:draw()
    local slab = self.game.slab;
    slab.BeginWindow("MMW");
    slab.Text(self.game.version);
    if (slab.Button("Levels")) then
        self.game:switchState("LevelListState");
    end
    if (slab.Button("Quit")) then
        love.event.push("quit");
    end
    slab.EndWindow();
end

function mms:resize(w, h)
end

return mms;
