
local material = (assert(loadfile('Materials/Soil.lua')))();
local MaterialBody = require 'Bodies/MaterialBody';
local PiroGame = require 'PiroGame/PiroGame';

local wb = PiroGame.class('Ground', MaterialBody);

function wb:initialize(x, y, rot, sx, sy, id)
    m = material;
    --m.graphics.texture.transforms = {};
    --table.insert(m.graphics.texture.transforms, {mode = 'translate', x = 50, y =50});
    --table.insert(m.graphics.texture.transforms, {mode = 'scale', x = 0.01, y = 0.01});
    --table.insert(m.graphics.texture.transforms, {mode = 'rotation', angle = 1});
    
    MaterialBody.initialize(self, m, 'static', {{0, 0}, {2000, 0}, {2000, 200}, {0, 200}}, x, y, rot, sx, sy, id);
end

return wb;
 
