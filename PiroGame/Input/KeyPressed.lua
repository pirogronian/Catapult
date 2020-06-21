
local args = ...

local KeyPressed = args.PiroGame.class("KeyPressed");

function KeyPressed:initialize(key, code, isrepeat)
    self.key = key;
    self.code = code;
    self.isRepeat = isrepeat;
end

return KeyPressed;
