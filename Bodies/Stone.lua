
local MaterialBody = require 'Bodies/MaterialBody';
local PiroGame = require 'PiroGame/PiroGame';

local wb = PiroGame.class('Stone', MaterialBody);

function wb:initialize(x, y, rot, sx, sy, id)
    m = assert(dofile('Materials/Rock.lua'));
--     table.insert(m.graphics.texture.transforms, {mode = 'translate', x = 50, y =50});
--     table.insert(m.graphics.texture.transforms, {mode = 'rotation', angle = love.math.random(0, 3)});
--     table.insert(m.graphics.texture.transforms, {mode = 'scale', x = love.math.random(0.1, 1), y = love.math.random(0.1, 1)});
    MaterialBody.initialize(self, m, 'dynamic', {{-10, 0}, {-7, -7}, {0, -10}, {7, -7}, {10, 0}, {7, 7}, {0, 10}, {-7, 7}}, x, y, rot, sx, sy, id);
end

return wb;
