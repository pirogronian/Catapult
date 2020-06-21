
local path = (...)

path = path:match("(.-)[^%/%.]+$");

local PiroGame = {};

function PiroGame:load(file)
--     print('loading module:', file);
    return (assert(loadfile(path .. file)))({path = path, PiroGame = self});
end

PiroGame.class = require (path .. 'middleclass');

PiroGame.filesystemToTable = PiroGame:load('FilesystemToTable.lua');
PiroGame.Action = PiroGame:load('Action.lua');
PiroGame.Entity = PiroGame:load('Entity.lua');
PiroGame.Component = PiroGame:load('Component.lua');
PiroGame.EventManager = PiroGame:load('EventManager.lua');
PiroGame.Scene = PiroGame:load('Scene.lua');
PiroGame.meshToPolygon = PiroGame:load('MeshToPolygon.lua');
PiroGame.Input = PiroGame:load('Input.lua');
PiroGame.Graphics = PiroGame:load('Graphics.lua');
PiroGame.Physics = PiroGame:load('Physics.lua');
PiroGame.Audio = PiroGame:load('Audio.lua');

return PiroGame;
