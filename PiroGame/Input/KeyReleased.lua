
local args = ...;

local KeyReleased = args.PiroGame.class("KeyReleased")

function KeyReleased:initialize(key)
    self.key = key
end

return KeyReleased;
