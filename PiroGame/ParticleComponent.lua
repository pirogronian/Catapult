
local args = ...;

local pc = args.PiroGame.class('ParticleComponent', args.PiroGame.Component);

function pc:initialize(image, buf, plife, rate, elife, id)
    args.PiroGame.Component(self, id);
    if type(image) == 'string' then
        image = love.graphics.newImage(image);
    end
    if type(buf) ~= 'number' or buf < 1 then
        error('Buffer has invalid value');
    end
    self.image = image;
    self.buffer = buf;
    self.particleLifetime = plife;
    self.rate = rate;
    self.emitterLifetime = elife;
end

function pc:activate()
    if self.drawable ~= nil then return; end
    self.drawable = love.graphics.newParticleSystem(self.image, self.buffer);
    if self.particleLifetime ~= nil then
        local min = 0;
        local max = 0;
        if type(self.particleLifetime) == 'table' then
            min = self.particleLifetime[1];
            max = self.particleLifetime[2];
        else
            min = self.particleLifetime;
            max = min;
        end
        self.drawable:setParticleLifetime(min, max);
    end
    if self.emitterLifetime ~= nil then
        self.drawable:setEmitterLifetime(self.emitterLifetime);
    end
    if self.rate ~= nil then
        self.drawable:setEmissionRate(self.rate);
    end
    if self.spread ~= nil then
        self.drawable:setSpread(self.spread);
    end
    if self.speed ~= nil then
        local min = 0;
        local max = 0;
        if type(self.speed) == 'table' then
            min = self.speed[1];
            max = self.speed[2];
        else
            min = self.speed;
            max = min;
        end
        self.drawable:setSpeed(min, max);
    end
    if self.rotation ~= nil then
        local min = 0;
        local max = 0;
        if type(self.rotation) == 'table' then
            min = self.rotation[1];
            max = self.rotation[2];
        else
            min = self.rotation;
            max = min;
        end
        self.drawable:setRotation(min, max);
    end
    if self.spin ~= nil then
        local min = 0;
        local max = 0;
        if type(self.spin) == 'table' then
            min = self.spin[1];
            max = self.spin[2];
        else
            min = self.spin;
            max = min;
        end
        self.drawable:setSpin(min, max);
    end
    if self.speed ~= nil then
        self.drawable:setSpeed(self.speed[1], self.speed[2]);
    end
    if self.linearAcceleration ~= nil then
        self.drawable:setLinearAcceleration(self.linearAcceleration[1], self.linearAcceleration[2], self.linearAcceleration[3], self.linearAcceleration[4]);
    end
    if self.radialAcceleration ~= nil then
        self.drawable:setRadialAcceleration(self.radialAcceleration[1], self.radialAcceleration[2]);
    end
    if type(self.areaSpread) == 'table' then
        self.drawable:setEmissionArea(self.areaSpread.method, self.areaSpread.x, self.areaSpread.y);
    end
    self.started = love.timer.getTime();
end

function pc:deactivate()
    self.drawable:stop();
    self.drawable = nil;
end

function pc:update(dt)
    if self.drawable == nil then return; end
    self.drawable:update(dt);
end

function pc:draw()
    if self.drawable == nil then return; end
    love.graphics.draw(self.drawable, self.entity.x, self.entity.y, 0, self.xscale, self.yscale);
end

function pc:dump()
    if self.drawable ~= nil then
        print('Buffer size:', self.drawable:getBufferSize());
        print('Emission rate:', self.drawable:getEmissionRate());
        print('Direction:', self.drawable:getDirection());
        print('Emitter lifetime:', self.drawable:getEmitterLifetime());
        print('Particles lifetime:', self.drawable:getParticleLifetime());
        print('Spread:', self.drawable:getSpread());
        print('Area spread:', self.drawable:getAreaSpread());
        print('Linear acceleration:', self.drawable:getLinearAcceleration());
        print('Radial acceleration:', self.drawable:getRadialAcceleration());
        print('Tangential acceleration:', self.drawable:getTangentialAcceleration());
        print('Speed:', self.drawable:getSpeed());
        print('Spin:', self.drawable:getSpin());
        print('Rotation:', self.drawable:getRotation());
        print('Linear damping:', self.drawable:getLinearDamping());
    end
end

return pc;
