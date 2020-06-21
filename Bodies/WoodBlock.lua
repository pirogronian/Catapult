
local MaterialBody = require 'Bodies/MaterialBody';
local PiroGame = require 'PiroGame/PiroGame';

local wb = PiroGame.class('WoodBlock', MaterialBody);

function wb:initialize(x, y, rot, sx, sy, id)
    m = assert(dofile('Materials/Wood.lua'));
    table.insert(m.graphics.texture.transforms, {mode = 'translate', x = 50, y =50});
    table.insert(m.graphics.texture.transforms, {mode = 'rotation', angle = love.math.random(0, 3)});
    table.insert(m.graphics.texture.transforms, {mode = 'scale', x = love.math.random(0.1, 1), y = love.math.random(0.1, 1)});
    MaterialBody.initialize(self, m, 'dynamic', {{-50, -10}, {50, -10}, {50, 10}, {-50, 10}}, x, y, rot, sx, sy, id);
end

return wb;
