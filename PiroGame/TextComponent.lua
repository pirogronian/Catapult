
local args = ...;

local dc = args.PiroGame:load('DrawableComponent.lua');

local tc = args.PiroGame.class('TextComponent', dc);

function tc:initialize(font, text)
    self.text = text;
    self.font = font;
end

function tc:activate()
    self.drawable = love.graphics.newText(self.font, self.text);
end

return tc;
