
local pg = require('PiroGame/PiroGame');

local od = pg.class('DestructionEvent');

function od:initialize(object)
    self.object = object;
--     print();
end

return od;
