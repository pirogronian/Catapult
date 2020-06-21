
local material = (assert(loadfile('Materials/Wood.lua')))();
local MaterialBody = require 'Bodies/MaterialBody';
local PiroGame = require 'PiroGame/PiroGame';

local wb = PiroGame.class('WoodStaticBlock', MaterialBody);

function wb:initialize(x, y, rot, sx, sy, id)
    m = material;
    m.graphics.texture.transforms = {};
    table.insert(m.graphics.texture.transforms, {mode = 'translate', x = 50, y =50});
    table.insert(m.graphics.texture.transforms, {mode = 'scale', x = 0.01, y = 0.01});
    table.insert(m.graphics.texture.transforms, {mode = 'rotation', angle = 1});

    MaterialBody.initialize(self, m, 'static', {{-50, -15}, {50, -10}, {50, 10}, {-50, 10}}, x, y, rot, sx, sy, id);
end

return wb;
 
