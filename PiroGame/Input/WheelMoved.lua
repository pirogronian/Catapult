
local args = ...;

local wm = args.PiroGame.class('WheelMoved');

function wm:initialize(x, y)
    self.x = x;
    self.y = y;
end

return wm;
