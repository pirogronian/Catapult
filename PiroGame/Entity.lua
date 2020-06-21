
local args = ...;

local entity = args.PiroGame.class('Entity');

function entity:initialize(x, y, rot, sx, sy, name, extra)
--     print('Entity initialiation:', self, x, y, rot, sx, sy, name, extra);
    if (x == nil) then
        self.x = 0;
    else
        self.x = x;
    end
    if (y == nil) then
        self.y = 0;
    else
        self.y = y;
    end
    if (rot == nil) then
        self.rot = 0;
    else
        self.rot = rot;
    end
    if (sx == nil) then
        self.sx = 1;
    else
        self.sx = sx;
    end
    if (sy == nil) then
        self.sy = 1;
    else
        self.sy = sy;
    end
    if name ~= nil then
        self.id = name;
    end

    self.components = {};
    self.children = {};
end

function entity:addComponent(comp, name)
--    print('Entity:', self, 'addComponent:', comp, comp.id);
    comp.entity = self;
    if name == nil then
        name = comp.class.name;
    end
    self.components[name] = comp;
end

function entity:getComponent(comp)
    if (type(comp) == 'table') then
        return self.components[comp.class.name];
    else
        return self.components[comp];
    end
end

function entity:removeComponend(comp)
    if (type(comp) == 'table') then
        self.components[comp.class.name] = nil;
    else
        self[comp] = nil;
    end
end

function entity:dumpComponents()
    print(self, 'dump components:');
    for k, c in pairs(self.components) do
        print(k, '(', type(k), ') =>', c);
    end
end

function entity:addChild(child, name)
    self.children[name] = child;
    child.parent = self;
end

function entity:getChild(name)
    return self.children[name];
end

function entity:removeChild(name)
    local child = self.children[name];
    if child ~= nil then
        self.children[name] = nil;
        child.parent = nil;
    end
end

function entity:getAbsolutePosition()
    local x, y = self.x, self.y;
    local i = self.parent;
    while i ~= nil do
        x = x + i.x;
        y = y + i.y;
        i = i.parent;
    end
    return x, y;
end

function entity:activate()
--     print('Entity activation:', self, 'Scene:', self.scene, 'Name:', self.id);
    for k, c in pairs(self.components) do
        if type(c.activate) == 'function' then
--            print('Entity', self, 'activate component', c, c.id);
            if c.noauto ~= true then
                c:activate();
            end
        end
    end
    for _, child in pairs(self.children) do
        child:activate();
    end
end

function entity:deactivate()
    if self.scene == nil then
        print(self, self.id, 'attempt to deactivate twice?!');
        return;
    end
--    print('Entity deactivation:', self, self.id);
    for _, c in pairs(self.components) do
--        print(self, self.id, c, c.id, 'deactivate');
        if type(c.deactivate) == 'function' then
            c:deactivate();
        end
    end
    for _, child in pairs(self.children) do
        child:deactivate();
    end
--    print('Entity deactivation done:', self, self.id);
end

function entity:update(dt)
    for _, c in pairs(self.components) do
        if type(c.update) == 'function' then
            c:update(dt);
        end
    end
end

function entity:draw()
    for _, c in pairs(self.components) do
        if type(c.draw) == 'function' then
            c:draw();
        end
    end
    love.graphics.push();
    love.graphics.translate(self.x, self.y);
    love.graphics.scale(self.sx, self.sy);
    love.graphics.rotate(self.rot);
    for _, child in pairs(self.children) do
        child:draw();
    end
    love.graphics.pop();
end

function entity:dump()
    print('Item:', self.id);
    print('x: ', self.x);
    print('y: ', self.y);
    print('rot: ', self.rot);
    print('sx: ', self.sx);
    print('sy: ', self.sy);
end

return entity;
