
local args = ...;

local dc = args.PiroGame.class('DrawableComponent', args.PiroGame.Component);

function dc:deactivate()
    self.drawable = nil;
end

function dc:draw()
    if self.drawable ~= nil then
        love.graphics.draw(self.drawable, self.entity.x, self.entity.y, self.entity.rot, self.entity.sx, self.entity.sy);
    end
end

return dc;
