
local args = ...;

local pc = args.PiroGame.class('PhysicsComponent', args.PiroGame.Component);

function pc:initialize(dtype, mass, density, friction, restitution, shapeType, shapeData, id)
    args.PiroGame.Component.initialize(self, id);
    self.type = dtype;
    self.mass = mass;
    self.density = density;
    self.friction = friction;
    self.restitution = restitution;
    self.shapeType = shapeType;
    self.shapeData = shapeData;
end

function pc:activate()
    if self.body ~= nil then return; end
    self.body = love.physics.newBody(self.entity.scene.world, self.x, self.y, self.type);
    self.body:setUserData(self.entity);
    self.body:setPosition(self.entity.x, self.entity.y);
    self.body:setAngle(self.entity.rot);
    self.body:setLinearDamping(0);
    self.body:setAngularDamping(0);
    if (self.mass ~= nil) then
        self.body:setMass(self.mass);
    end
    if (self.shapeType == 'circle') then
        self.shape = love.physics.newCircleShape(self.shapeData);
    end
    if (self.shapeType == 'polygon') then
        self.shape = love.physics.newPolygonShape(self.shapeData);
    end
    if (self.shapeType == 'chain') then
        self.shape = love.physics.newChainShape(self.shapeData);
    end
    if (self.shape == nil) then
        error('Invalid shape type');
    else

    end
    fixture = love.physics.newFixture(self.body, self.shape, self.density);
    if self.restitution ~= nil then
        fixture:setRestitution(self.restitution);
    end
    if self.friction ~= nil then
        fixture:setFriction(self.friction);
    end
    if (self.density ~= nil) then
        fixture:setDensity(self.density);
    end
    self.fixture = fixture;
end

function pc:deactivate()
    if self.body == nil then return; end
--    print(self, self.id, 'deactivate', self.body, self.fixture, self.shape);
    self.fixture:destroy();
    self.body:destroy();
    self.fixture = nil;
    self.body = nil;
    self.shape = nil;
end

function pc:update(dt)
    if self.body == nil then return; end
--    print(self.body:getPosition());
    self.entity.x, self.entity.y = self.body:getPosition();
    self.entity.rot = self.body:getAngle();
end

function pc:dump()
--     print(self, 'dump of', self.id)
--     print(self, 'body type:', self.type, 'shape type', self.shapeType)
    if (self.body ~= nil) then
        print(self, 'real body:', self.body, self.body:getType(), self.shape:getType(), 'mass:', self.body:getMass());
    end
--     print(self, 'fixture: density:', self.density, 'friction:', self.friction, 'restitution:', self.restitution);
    if self.fixture ~= nil then
--         print(self, 'fixture: density:', self.fixture:getDensity(), 'friction:', self.fixture:getFriction(), 'restitution:', self.fixture:getRestitution());
    end
--[[    if self.shape ~= nil then
        if self.shape:getType() == 'circle' then
            print(self, 'radius:', self.shape:getRadius());
        else
            for k, v in pairs(self.shapeData) do
                print(k, ':', v)
            end

        end
    end]]
end

return pc;
