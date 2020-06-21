
local pg = require 'PiroGame/PiroGame';

local Arrow = pg.class("Arrow", pg.Entity);

function Arrow:initialize(x, y, rot, sx, sy, name)
    pg.Entity.initialize(self, x, y, rot, sx, sy, name);
    local strip = {
            { -10, -10 },
            { -10, 10 },
            { 50, 5 },
            { 60, 0 },
            { 50, -5 }
        };
    local me = pg.Graphics.MeshComponent:new(strip);
    self:addComponent(me);
end

local Rotator = pg.class("Rotator", pg.Entity);

function Rotator:initialize(x, y, rot, sx, sy, name)
    pg.Entity.initialize(self, x, y, rot, sx, sy, name);
    local arrobj = Arrow:new(0, 0, 0, 1, 1, "Arrow");
    self:addChild(arrobj, "arrow");
end

local Catapult = pg.class("Catapult", pg.Entity);

function Catapult:activate()
    pg.Entity.activate(self);
    self:changeStrength(0);
end

function Catapult:deactivate()
    pg.Entity.activate(self);
end

function Catapult:setProjectile(pr)
    local pc = pr:getComponent('PhysicsComponent');
    pc.noauto = true;
    self:getChild("rotator"):addChild(pr, "projectile");
    self.projectile = pr;
    self.projectile:activate();
end

function Catapult:removeProjectile()
    self:getChild('rotator'):removeChild('projectile');
    self.projectile = nil;
end

function Catapult:throw()
    if self.projectile ~= nil then
        local pr = self.projectile;
        pr.x, pr.y = pr:getAbsolutePosition();
        local rotator = self:getChild('rotator');
        rotator:removeChild('projectile');
        self.projectile = nil;
        pr.rot = rotator.rot;
        self.scene:addEntity(pr);
        local pc = pr:getComponent('PhysicsComponent');
        if pc ~= nil then
            pc:activate();
            local rmx = love.math.newTransform();
            rmx:rotate(rotator.rot);
            ix, iy = rmx:transformPoint(self.strength, 0);
            pc.body:applyLinearImpulse(ix, iy);
        end
    end
end

function Catapult:rotate(angle)
    self.children["rotator"].rot = self.children["rotator"].rot + angle;
end

function Catapult:changeStrength(num)
    self.strength = self.strength + num;
    if self.strength < 0 then
        self.strength = 0;
    else
        if self.strength > self.maxStrength then
            self.strength = self.maxStrength;
        end
    end
end

function Catapult:initialize(x, y, name)
    pg.Entity.initialize(self, x, y, 0, 1, 1, name);
    local rotobj = Rotator:new(0, 0, 0, 1, 1, "Rotator");
    self:addChild(rotobj, "rotator");
    self.strength = 500;
    self.maxStrength = 1500;
end

return Catapult;
