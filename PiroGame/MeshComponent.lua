
local args = ...;

local drawable = args.PiroGame:load('DrawableComponent.lua');

local mc = args.PiroGame.class('MeshComponent', drawable);

function mc:initialize(verts, mode, usage, texture, id)
    args.PiroGame.Component.initialize(self, id);
    self.type = 'mesh';
    self.vertices = verts;
    self.mode = mode;
    self.usage = usage;
    self.texture = texture;
end

function mc:activate()
    if self.drawable ~= nil then return; end
--    print('MeshComponent', self, self.id, 'activation. For', self.entity, self.entity.id);
    self.drawable = love.graphics.newMesh(self.vertices, self.mode, self.usage);
    if (self.texture ~= nil) then
        self.drawable:setTexture(self.texture);
    end
end

function mc:dump()
    print(self, 'dump of:', self.id);
    print(self, 'type:', self.type);
end

return mc;
