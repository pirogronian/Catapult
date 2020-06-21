
local args = ...;

local scene = args.PiroGame.class('Scene');

function scene:initialize(eventManager, world, gravity)
    self.transform = {};
    self.objects = {};
    self.drawn = {};
    self.updated = {};

    self.transform.scale = 1;
    self.transform.x = 0;
    self.transform.y = 0;

    self.move = { x = 0; y = 0; }

    if world ~= nil and world == true then
        if gravity == nil then
            gravity = { x = 0, y = 0 };
        end

        self.world = love.physics.newWorld(gravity.x, gravity.y, true);
        self.world:setCallbacks(self.beginContact, nil, nil, self.postSolve);
        love.physics.setMeter(48);
    end
    if eventManager ~= nil then
        self.eventManager = eventManager;
    else
        self.eventManager = args.PiroGame.EventManager:new();
    end
end

function scene:getWidth()
    if self.leftLimit ~= nil and self.rightLimit ~= nil then
        return self.rightLimit - self.leftLimit;
    else
        return nil;
    end
end

function scene:getHeight()
    if self.topLimit ~= nil and self.bottomLimit ~= nil then
        return self.bottomLimit - self.topLimit;
    else
        return nil;
    end
end

function scene:adjustShift()
    local x = self.transform.x;
    local y = self.transform.y;
    local wx, wy = love.window.getMode();
    local sw = self:getWidth();
    if sw ~= nil and sw / self.transform.scale < wx then
        x = (wx - self.transform.scale * (self.leftLimit + self.rightLimit)) / 2;
    else
        if self.rightLimit ~= nil and wx - self.rightLimit / self.transform.scale > x then
            x = wx - self.rightLimit * self.transform.scale;
        end
        if self.leftLimit ~= nil and -self.leftLimit / self.transform.scale < x then
            x = - self.leftLimit / self.transform.scale;
        end
    end
    self.transform.x = x;
    local sh = self:getHeight();
    if sh ~= nil and sh / self.transform.scale < wy then
        y = (wy - self.transform.scale * (self.topLimit + self.bottomLimit)) / 2;
    else
        if self.bottomtLimit ~= nil and wy - self.bottomLimit / self.transform.scale > y then
            y = wy - self.bottomtLimit / self.transform.scale;
        end
        if self.topLimit ~= nil and - self.topLimit / self.transform.scale < y then
            y = - self.topLimit / self.transform.scale;
        end
    end
    self.transform.y = y;
end

function scene:shift(dx, dy)
    self:setShift(self.transform.x + dx / self.transform.scale, self.transform.y + dy / self.transform.scale);
end

function scene:setShift(x, y)
    self.transform.x = x;
    self.transform.y = y;
--     self:adjustShift();
end

function scene:scale(s, x, y)
    local s2 = self.transform.scale + s;
    local ps = self.transform.scale;
    if s2 <= 0 then
        return;
    end
    if x == nil then
        x = 0;
    end
    if y == nil then
        y = 0;
    end
    local rx = (x * ps + self.transform.x) / ps;
    local mx =  - rx * s + self.transform.x;
    local ry = (y * ps + self.transform.y) / ps;
    local my =  - ry * s + self.transform.y;
    self.transform.scale = s2;
    self.transform.x = mx;
    self.transform.y = my;
end

function scene:scalePhysics(s)
    love.physics.setMeter(s);
    if (self.gravity ~= nil) then
        xg, yg = self.world:getGravity();
        self.world:setGravity(xg * s, yg * s);
    end
end

function scene:addEntity(item)
--      print('Scene:addEntity', item, item.id);
    item.scene = self;

    self.objects[item] = item;

    if type(item.draw) == 'function' then
        self.drawn[item.id] = item;
    end

    if type(item.update) == 'function' then
        self.updated[item.id] = item;
    end

--    print('Scene: entity added:', item, item.scene);

    if type(item.activate) == 'function' then
        item:activate();
    end

end

function scene:removeEntity(item)
--    print('remove entity:', item, item.id);
    if type(item.draw) == 'function' then
        self.drawn[item.id] = nil;
    end

    if type(item.update) == 'function' then
        self.updated[item.id] = nil;
    end

    if type(item.deactivate) == 'function' then
        item:deactivate();
    end

    self.objects[item] = nil;
    item.scene = nil;
--     print('Entity removed:', item, item.id, item.x, item.y);
end

function scene:hasEntity(entity)
    if self.drawn[entity.id] ~= nil or self.updated[entity.id] then return true; end
    return false;
end

function scene:getEntity(id)
    if self.drawn[id] ~= nil then
        return self.drawn[id];
    end
    if self.updated[id] ~= nil then
        return self.updated[id];
    end
end

function scene.beginContact(fix1, fix2, cont)
    entity1 = fix1:getBody():getUserData();
    entity2 = fix2:getBody():getUserData();
--    print('Collision between', entity1, 'and', entity2);
    if type(entity1.beginContact) == 'function' then
        entity1:beginContact(entity2, cont);
    end
    if type(entity2.beginContact) == 'function' then
        entity2:beginContact(entity1, cont);
    end
end

function scene.postSolve(fix1, fix2, cont, ni1, ti1, ni2, ti2)
    e1 = fix1:getBody():getUserData();
    e2 = fix2:getBody():getUserData();
--    print('postSolve:', e1, e1.id, e2, e2.id);

    if ni1 == nil then ni1 = 0; end
    if ni2 == nil then ni2 = 0; end
    if ti1 == nil then ti1 = 0; end
    if ti2 == nil then ti2 = 0; end
    if ni1 < 0 then ni1 = -ni1; end
    if ni2 < 0 then ni2 = -ni2; end
    if ti1 < 0 then ti1 = -ti1; end
    if ti2 < 0 then ti2 = -ti2; end
    ni = ni1 + ni2;
    ti = ti1 + ti2;
    if e1.scene ~= nil and type(e1.impulses) == 'function' then
        e1:impulses(ni, ti);
    end
    if e2.scene ~= nil and type(e2.impulses) == 'function' then
        e2:impulses(ni, ti);
    end
--    print('postSolve: done');
end

function scene:load(def)
    if type(def.Bodies) == 'table' then
        for _, b in pairs(def.Bodies) do
            self:addEntity(b);
        end
    end
end

function scene:update(dt)
    if self.world ~= nil then
        self.world:update(dt);
    end
    for _, i in pairs(self.updated) do
        --print('Update entity', i);
        if (self.rightLimit ~= nil and i.x > self.rightLimit) or
            (self.leftLimit ~=nil and i.x < self.leftLimit) or
            (self.topLimit ~=nil and i.y < self.topLimit) or
            (self.bottomLimit ~=nil and i.y > self.bottomLimit) then
            self:removeEntity(i)
        else
            i:update(dt);
        end
    end
end

function scene:draw()
    love.graphics.push();
    love.graphics.scale(self.transform.scale);
    love.graphics.translate(self.transform.x, self.transform.y);

    for _,i in pairs(self.drawn) do
        i:draw();
    end

    love.graphics.pop();
end

function scene:clear()
    local objs = {};
    for k, o in pairs(self.objects) do
        objs[k] = o;
    end
    for _, o in pairs(objs) do
        self:removeEntity(o);
    end
end

return scene;
