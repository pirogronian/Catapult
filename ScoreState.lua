
local pg = require 'PiroGame/PiroGame';

local gs = require 'GameState';

local ss = pg.class('ScoreState', gs);

function ss:initialize(game)
    gs.initialize(self, game);
    self.game:loadScores();
end

function ss.quitSeq(seq)
    seq.gameState.game:switchState('MainMenuState');
end

return ss;
