
local pg = require('PiroGame/PiroGame'); 

local game = pg.class('Game');

function game:update(delta)
    self.slab.Update(delta);
    self.states[self.currentState]:update(delta);
end

function game:draw()
    self.states[self.currentState]:draw();
    
    self:saveColor();
    self.slab.Draw();
    self:restoreColor();
end

function game:keypressed(key, code, isrepeat)
    self.eventManager:fireEvent(pg.Input.KeyPressed:new(key, code, isrepeat));
end

function game:keyreleased(key)
    self.eventManager:fireEvent(pg.Input.KeyReleased:new(key));
end

function game:mousepressed(x, y, buttons)
    self.eventManager:fireEvent(pg.Input.MousePressed:new(x, y, buttons));
end

function game:mousereleased(x, y, buttons)
    self.eventManager:fireEvent(pg.Input.MouseReleased:new(x, y, buttons));
end

function game:mousemoved(x, y, dx, dy, touch)
    self.eventManager:fireEvent(pg.Input.MouseMoved:new(x, y, dx, dy, touch));
end

function game:wheelmoved(x, y)
    self.eventManager:fireEvent(pg.Input.WheelMoved:new(x, y));
end

function game:addState(name)
    local sc = require(name);
    self.states[name] = sc:new(self);
end

function game:loadScores()
    self.scoreFile:open('r');
    local data = self.scoreFile:read();
    self.scoreFile:close();
    if data ~= nil then
        self.levelScores = self.bitser.loads(data);
    end
    if type(self.levelScores) ~= 'table' then
        self.levelScores = {};
    end
end

function game:saveScores()
    local data = self.bitser.dumps(self.levelScores);
    self.scoreFile:open('w');
    self.scoreFile:write(data);
    self.scoreFile:close();
end

function game:addScore(level, nick, time, points)
    local record = { nick = nick, time = time, points = points };
    if type(self.levelScores) ~= 'table' then
        self:loadScores();
    end
    if type(self.levelScores[level]) == 'table' then
        table.insert(self.levelScores[level], record);
    else
        self.levelScores[level] = { record };
    end
    self:saveScores();
end

function game:saveColor()
    sc = self.ui.savedColor;
    sc.r, sc.g, sc.b, sc.a = love.graphics.getColor();
end

function game:restoreColor()
    sc = self.ui.savedColor;
    love.graphics.setColor(sc.r, sc.g, sc.b, sc.a);
end

function game:initialize(args)
    self.version = "Catapult 07062020";
    self.font = love.graphics.newFont(20);
    self.eventManager = pg.EventManager:new();
    self.bitser = require('thirdparty/bitser/bitser');
    self.slab = require('thirdparty/Slab');
    self.slab.Initialize();
    self.ui = { savedColor = {} };
    self.states = {};
    self.scoreFile = love.filesystem.newFile('score.dat');
    self:addState('MainMenuState');
    self:addState('LevelListState');
    self:addState('PlayState');
    self:addState('ScoreState');
    self:addState('SaveScoreState');
    self:switchState('MainMenuState');
end

function game:switchState(name)
    local state = self.states[self.currentState];
    if state ~= nil and type(state.deactivate) == 'function' then
        state:deactivate();
    end
    self.currentState = name;
    state = self.states[self.currentState];
    if type(state.activate) == 'function' then
        state:activate();
    end
end

function game:resize(w, h)
    for name, state in pairs(self.states) do
        if type(state.resize) == 'function' then
            state:resize(w, h);
        end
    end
end

return game;
