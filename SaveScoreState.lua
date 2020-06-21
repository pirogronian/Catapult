
local pg = require 'PiroGame/PiroGame';
local gs = require 'GameState';
local sss = pg.class('SaveScoreState', gs);

function sss:save(nick)
    self.game:addScore(self.game.currentScore.name, nick, self.game.currentScore.time, self.game.currentScore.points);
    self.game:switchState('LevelListState');
end

function sss:initialize(game)
    gs.initialize(self, game);
    self:resize(love.window.getMode());
end

function sss:activate()
    gs.activate(self);
end

function sss:deactivate()
    gs.deactivate(self);
end

function sss:resize(w, h)
end

return sss;
