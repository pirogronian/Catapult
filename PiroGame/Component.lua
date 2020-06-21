
local args = ...;

local Component = args.PiroGame.class('Component');

function Component:initialize(id)
    self.id = id;
end

return Component;
