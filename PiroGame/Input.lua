
local args = ...;

InputNamespace = {};

InputNamespace.KeyPressed = args.PiroGame:load('Input/KeyPressed.lua');
InputNamespace.KeyReleased = args.PiroGame:load('Input/KeyReleased.lua');
InputNamespace.MousePressed = args.PiroGame:load('Input/MousePressed.lua');
InputNamespace.MouseReleased = args.PiroGame:load('Input/MouseReleased.lua');
InputNamespace.MouseMoved = args.PiroGame:load('Input/MouseMoved.lua');
InputNamespace.WheelMoved = args.PiroGame:load('Input/WheelMoved.lua');
InputNamespace.KeySequence = args.PiroGame:load('Input/KeySequence.lua');
InputNamespace.KeyGroup = args.PiroGame:load('Input/KeyGroup.lua');
InputNamespace.KeyAltGroup = args.PiroGame:load('Input/KeyAltGroup.lua');

return InputNamespace;
