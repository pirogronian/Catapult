
local args = ...;

local mm = args.PiroGame.class('MouseMoved');

function mm:initialize(x, y, dx, dy, touch)
    self.x = x;
    self.y = y;
    self.dx = dx;
    self.dy = dy;
    self.touch = touch;
end

return mm;
