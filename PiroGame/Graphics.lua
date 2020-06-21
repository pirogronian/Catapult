
local args = ...;

local Graphics = {};

Graphics.Texture = args.PiroGame:load('Texture.lua');
Graphics.DrawableComponent = args.PiroGame:load('DrawableComponent.lua');
Graphics.MeshComponent = args.PiroGame:load('MeshComponent.lua');
Graphics.TextComponent = args.PiroGame:load('TextComponent.lua');
Graphics.ParticleComponent = args.PiroGame:load('ParticleComponent.lua');

return Graphics;
