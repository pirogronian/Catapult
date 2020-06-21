
local pg = require('PiroGame/PiroGame');

local debug = require('Debug');

local gs = pg.class('GameState');

function gs:initialize(game)
    self.game = game;
    self.eventManager = game.eventManager;
    self.keySequences = {};
    self.keyGroups = {};
end

function gs:activate()
    for _, seq in pairs(self.keySequences) do
        seq:startListen();
    end
end

function gs:deactivate()
    for _, seq in pairs(self.keySequences) do
        seq:stopListen();
    end
end

function gs:addKeySequence(keys, method)
    local ks = pg.Input.KeySequence:new(keys, self.game.eventManager);
    ks.gameState = self;
    ks.activated = method;
    table.insert(self.keySequences, ks);
end

function gs:addKeyGroup(keys, method)
    local kg = pg.Input.KeyGroup:new(keys);
    kg.gameState = self;
    kg.update = method;
    table.insert(self.keyGroups, kg);
end

function gs:update(dt)
    for _, gr in pairs(self.keyGroups) do
        if gr:isDown() and type(gr.update) == 'function' then
            gr:update(dt);
        end
    end
end

function gs:draw()
end

return gs;
