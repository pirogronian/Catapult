
local args = ...;

local Action = args.PiroGame.class('Action');

Action.eventManaget = nil;
Action.event = nil;

function Action:activate()
    if (self.eventManager and self.event) then
        self.eventManager:fireEvent(self.event);
    end
end

return Action;
