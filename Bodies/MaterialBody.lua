

local PiroGame = require 'PiroGame/PiroGame';

local mb = PiroGame.class('MaterialBody', PiroGame.Entity);

local DestEvent = require('Events/DestructionEvent');

function mb:initialize(material, dynamics, meshVerts, x, y, rot, sx, sy, id)
    PiroGame.Entity.initialize(self, x, y, rot, sx, sy, id);

    if material ~= nil then
        if material.graphics ~= nil then
--             print(self, 'initializing graphics...');
            if material.graphics.texture ~= nil then
--                 print(':initializing vertices and texture...');
                local tex = nil;
                local mode = 'fan';
                local usage = 'dynamic';
                local wrapx = 'repeat';
                local wrapy = 'repeat';

                if material.graphics.mode ~= nil then
                    mode = material.graphics.mode;
                end

                if material.graphics.mode ~= nil then
                    usage = material.graphics.usage;
                end

                if material.graphics.texture.file ~= nil then
                    if material.graphics.texture.wrapx ~= nil then
                        wrapx = material.graphics.texture.wrapx;
                    end

                    if material.graphics.texture.wrapy ~= nil then
                        wrapy = material.graphics.texture.wrapy;
                    end

                    tex = love.graphics.newImage(material.graphics.texture.file);
                    tex:setWrap(wrapx, wrapy);
                end

                local verts = PiroGame.Graphics.Texture.meshUVFromGeometry(meshVerts);
                if material.graphics.texture.transforms ~= nil then
--                     print('::transforming texture UV...');
                    for _i, v in pairs(material.graphics.texture.transforms) do
                        if v.mode == 'translate' then
--                             print(':::', v.mode, v.x, v.y);
                            verts = PiroGame.Graphics.Texture.meshUVTranslate(verts, v.x, v.y);
                        end
                        if v.mode == 'scale' then
--                             print(':::', v.mode, v.x, v.y);
                            verts = PiroGame.Graphics.Texture.meshUVScale(verts, v.x, v.y);
                        end
                        if v.mode == 'rotation' then
--                             print(':::', v.mode, v.angle);
                            verts = PiroGame.Graphics.Texture.meshUVRotate(verts, v.angle);
                        end
                    end
                end

                local drawId = 'drawable';
                if type(id) == 'string' then
                    drawId = id .. '_' .. drawId;
                end

                self:addComponent(PiroGame.Graphics.MeshComponent:new(verts, mode, usage, tex, drawId));
            end
            if material.graphics.destruction ~= nil then
                if material.graphics.destruction.image ~= nil then
--                     print(':initializing particle system')
                    partId = 'particle';
                    if type(id) == 'string' then
                        partId = id .. '_' .. partId;
                    end
--                     print('::image:', material.graphics.destruction.image);
                    pc = PiroGame.Graphics.ParticleComponent:new(material.graphics.destruction.image, 32, 1, 180, 0.1, partId);
                    scale = material.graphics.destruction.scale;
                    if scale ~= nil then
                        if type(scale) == 'table' then
                            pc.xscale = scale[1];
                            pc.yscale = scale[2];
                        else
                            pc.xscale = scale;
                            pc.yscale = scale;
                        end
                    else
                        pc.xscale = 1;
                        pc.yscale = 1;
                    end
                    pc.spread = 2 * math.pi;
                    --pc.speedTime = 1;
                    pc.spin = { -math.pi, math.pi };
                    pc.rotation = { -math.pi, math.pi };
                    pc.speed = { 10, 500 };
                    pc.linearAcceleration = {0, 600, 0, 600};
                    pc.areaSpread = {method = 'uniform', x = 10, y = 10};
--                     pc.radialAcceleration = {-100, -400};
                    self:addComponent(pc, 'DestructionParticles');
                end
            end
        end

        if material.physics ~= nil then
--             print(self, 'initializing physics...');
            local shapetype = 'polygon';
            local shapedata = nil;

            if material.physics.hitThreshold ~= nil then self.hitThreshold = material.physics.hitThreshold;
            else self.hitThreshold = 10; end
--             print('Hit threshold:', self.hitThreshold);

            if material.physics.breakThreshold ~= nil then self.breakThreshold = material.physics.breakThreshold;
            else self.breakThreshold = 20; end
--             print('Break threshold:', self.breakThreshold);

            if material.physics.shape ~= nil then
                if material.physics.shape.mode ~= nil then
                    shapetype = material.physics.shape.mode;
                end
                if material.physics.shape.vertices ~= nil then
                    shapeverts = material.physics.shape.vertices;
                else
                    if shapetype == 'polygon' or shapetype == 'chain' then
                        shapeverts = PiroGame.meshToPolygon(meshVerts);
                    end
                end

                if material.physics.shape.mode == 'circle' then
                    shapedata = material.physics.shape.radius;
                end
            end

            physId = 'Physics';
            if type(id) == 'string' then
                physId = id .. '_' .. physId;
            end

            self:addComponent(PiroGame.Physics.PhysicsComponent:new(dynamics, nil, material.physics.density, material.physics.friction, material.physics.restitution, shapetype, shapeverts, physId));
        end

        if material.audio ~= nil then
--             print(self, 'initializing audio...');
            if material.audio.onhit ~= nil then
                audioId = 'HitSound';
                if type(id) == 'string' then
                    audioId = id .. '_' .. audioId;
                end

                self:addComponent(PiroGame.Audio.AudioComponent:new(material.audio.onhit.file, 'static', audioId), 'HitAudio');
            end
            if material.audio.ondestroy ~= nil then
                audioId = 'DestroySound';
                if type(id) == 'string' then
                    audioId = id .. '_' .. audioId;
                end

                self:addComponent(PiroGame.Audio.AudioComponent:new(material.audio.ondestroy.file, 'static', audioId), 'DestroyAudio');
            end
        end
    end

    self.totalLinearImpulse = 0;
    self.totalTangentImpulse = 0;
    self.destroyed = false;

end

function mb:beginDestruction()
    pc = self:getComponent('DestructionParticles');
    if pc ~= nil then
        phc = self:getComponent('PhysicsComponent');
        if phc ~= nil then
            phc:deactivate();
        end
        self.destructionStart = love.timer.getTime();
        self:getComponent('MeshComponent'):deactivate();
        pc:activate();
    end
    da = self:getComponent("DestroyAudio");
    if da ~= nil then
        da:play();
    end
    self.scene.eventManager:fireEvent(DestEvent:new(self));
end

function mb:finishDestruction()
--     print(self, self.id, 'finishDestruction')
    self.destructionStart = nil;
    self.scene:removeEntity(self);
    self.destroyed = true;
end

function mb:beginContact(entity, contact)
--    print(self, 'Hit!');

end

function mb:impulses(ni, ti)
    if ni == nil or ni < 0 then ni = 0; end
    if ti == nil or ti < 0 then ti = 0; end

    self.totalLinearImpulse = self.totalLinearImpulse + ni;
    self.totalTangentImpulse = self.totalTangentImpulse + ti;
end

function mb:update(dt)
    if type(self.destructionStart) == 'number' then
        lt = love.timer.getTime() - self.destructionStart;
        if lt > 2 then
            self:finishDestruction();
--             print('Destruction finished after', lt);
        else
            self:getComponent('DestructionParticles'):update(dt);
        end
    else
        totalImpulse = self.totalLinearImpulse + self.totalTangentImpulse;
        if type(self.breakThreshold) == 'number' and totalImpulse > self.breakThreshold then
--             print(self, self.id, 'impulse:', totalImpulse, 'destroying...');
            self:beginDestruction();
        else
            if totalImpulse > self.hitThreshold then
                --print(self, self.id, 'impulse:', totalImpulse, 'hitting...');
                hit = self:getComponent('HitAudio');
                if hit ~= nil then
                    hit:play();
                else
            --        print(self, 'no audio hit component!');
                end
            end
        end

        self.totalLinearImpulse = 0;
        self.totalTangentImpulse = 0;
        if self.destroyed == false then
            self:getComponent('PhysicsComponent'):update(dt);
        end
    end

end

return mb;
