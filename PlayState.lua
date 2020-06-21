
local pg = require('PiroGame/PiroGame');
local gs = require('GameState');
local ps = pg.class('PlayState', gs);

local debug = require('Debug');

local points = require('Points');

function ps:escape()
    self.gameState.game:switchState('LevelListState');
end

function ps.moveLeftUpdate(group, dt)
    local d = 1000;
    if group.gameState.shiftKey:isDown() then
        d = 100;
    end
--     print(string.format('moveLeftUpdate(%s, %f): %ux%u', group, dt, group.gameState.scene.transform.x, group.gameState.scene.transform.y));
    group.gameState.scene.transform.x = group.gameState.scene.transform.x + dt * d;
end

function ps.moveRightUpdate(group, dt)
    local d = 1000;
    if group.gameState.shiftKey:isDown() then
        d = 100;
    end
--     print(string.format('moveRightUpdate(%s, %f): %ux%u', group, dt, group.gameState.scene.transform.x, group.gameState.scene.transform.y));
    group.gameState.scene.transform.x = group.gameState.scene.transform.x - dt * d;
end

function ps.moveUpUpdate(group, dt)
    local d = 1000;
    if group.gameState.shiftKey:isDown() then
        d = 100;
    end
--     print(string.format('moveUpUpdate(%s, %f): %ux%u', group, dt, group.gameState.scene.transform.x, group.gameState.scene.transform.y));
    group.gameState.scene.transform.y = group.gameState.scene.transform.y + dt * d;
end

function ps.moveDownUpdate(group, dt)
    local d = 1000;
    if group.gameState.shiftKey:isDown() then
        d = 100;
    end
--     print(string.format('moveDownUpdate(%s, %f): %ux%u', group, dt, group.gameState.scene.transform.x, group.gameState.scene.transform.y));
    group.gameState.scene.transform.y = group.gameState.scene.transform.y - dt * d;
end

function ps.rotUpUpdate(group, dt)
    if group.gameState.paused == true then
        return;
    end
    group.gameState.catapult:rotate(-dt);
end

function ps.rotDownUpdate(group, dt)
    if group.gameState.paused == true then
        return;
    end
    group.gameState.catapult:rotate(dt);
end

function ps.incStrenUpdate(group, dt)
    if group.gameState.paused == true then
        return;
    end
    local d = 1000;
    if group.gameState.controlKey:isDown() then
        d = 100;
    end
    group.gameState.catapult:changeStrength(dt * d);
    group.gameState:updateStrenText();
end

function ps.decStrenUpdate(group, dt)
    if group.gameState.paused == true then
        return;
    end
    local d = 1000;
    if group.gameState.controlKey:isDown() then
        d = 100;
    end
    group.gameState.catapult:changeStrength(- dt * d);
    group.gameState:updateStrenText();
end

function ps:update(dt)

end

function ps:updateSceneDebug()
    self.debugSceneText:SetText(string.format('Transforms: %d, %d, %f', self.scene.transform.x, self.scene.transform.y, self.scene.transform.scale));
end

function ps.throwSeq(seq)
    if seq.gameState.paused ~= true then
        seq.gameState:throw();
    end
end

function ps:throw()
    if self.catapult.projectile == nil then
        return;
    end
    if points[self.catapult.projectile.class.name] ~= nil then
        self.score = self.score - points[self.catapult.projectile.class.name] * self.catapult.strength / 1000;
        self:updateScoreText();
    end
    self.catapult:throw();
    self:loadProjectile();
end

function ps:destruction(event)
    if event.object.projectile ~= true and points[event.object.class.name] ~= nil then
        self.score = self.score + points[event.object.class.name];
        self:updateScoreText();
    end
    if event.object.otd == true then
        self.otdn = self.otdn - 1;
        if self.otdn == 0 then
            self:finish();
        end
    end
end

function ps:mousemoved(event)
    if love.mouse.isDown(2) then
        self.scene:shift(event.dx, event.dy);
    end
end

function ps:wheelmoved(event)
    self.scene:scale(event.y / 50, love.mouse.getPosition());
end

function ps:updateScoreText()
    self.scoreText = string.format('Score: %d', self.score);
end

function ps:initialize(game)
    gs.initialize(self, game);
    self.scene = pg.Scene:new(self.eventManager, true, { x = 0, y = 50 });
    self.score = 0;
    self.projNr = 0;
    self.eventManager:addListener('DestructionEvent', self, self.destruction);
    self:resize(love.window.getMode());
    self:updateScoreText();
end

function ps:activate()
    gs.activate(self);
    self.eventManager:addListener('MouseMoved', self, self.mousemoved);
    self.eventManager:addListener('WheelMoved', self, self.wheelmoved);
    self.projNr = 0;
    self.score = 0;
    self:loadLevel(self.game.level);
    if self.catapult == nil then
        print('No catapult object in scene? With what are you want to throw your pojectiles??');
    end
end


function ps:deactivate()
    gs.deactivate(self);
    self.eventManager:removeListener('MouseMoved', self);
    self.eventManager:removeListener('WheelMoved', self);
    self.scene:clear();
    self.projList:Clear();
end

function ps:update(dt)
    gs.update(self, dt);
    if self.paused ~= true then
        self.scene:update(dt);
    end
    w, h, flags = love.window.getMode();
    local slab = self.game.slab;
    slab.BeginWindow(
        "PlayStateStatusWindow",
        {
            X = 0, Y = 0, W = w, H = 50, ContentW = w, AllowMove = false, AllowResize = false, AutoSizeWindow = false
        }
        );
    slab.BeginLayout("PlayStateStatusLayout", { AlignX = "left", Columns = 2, AnchorX = true, AnchorY = true });
    slab.Text("Score:");
    slab.Text(self.score);
    slab.EndLayout();
    slab.EndWindow();

    slab.BeginWindow("PCLW", { Title = "Avaliable projectiles" });
    for class, count in ipairs(self.Projectiles) do
        slab.BeginLayout("PCLL" .. class.name);
        slab.Text(class.name);
        slab.Text(count);
        if slab.Button("PCLB" .. class.name) then
            self:setProjclass(class);
        end
        slab.EndLayout();
    end
    slab.EndWindow();
    
    slab.BeginWindow("CatapultInfo", { Title = "Catapult info" });
    slab.BeginLayout("");
    slab.Text("Strength:");
    slab.Text(self.catapult.strength);
    slab.EndLayout();
    slab.EndWindow();

    slab.BeginWindow("PlayStateDebugWindow", { Title = "Debug info", AutoSizeWindow = false });
    slab.BeginLayout("PlayStateDebugLayout", { Columns = 2 });
    slab.Text("Background Color:");
    r, g, b, a = love.graphics.getBackgroundColor();
    slab.Text(string.format("[%f, %f, %f, %f]", r, g, b, a));
    slab.Text("Color:");
    r, g, b, a = love.graphics.getColor();
    slab.Text(string.format("[%f, %f, %f, %f]", r, g, b, a));
    slab.EndLayout();
    slab.EndWindow();
end

function ps:draw()
    self.scene:draw();
--     self:updateSceneDebug();
end

function ps:resize(w, h)
end

function ps:setProjClass(class)
    self:unloadProjectile();
    self.currentProj = { projClass = class, projCount = self.Projectiles[class.name].count };
    self:loadProjectile();
end

function ps:loadProjectile()
    if self.currentProj == nil then
        return;
    end
    if self.currentProj.projCount == 0 then
        return;
    end
    local proj = self.currentProj.projClass:new();
    proj.id = 'Projectile' .. self.projNr;
    proj.projectile = true;
    self.projNr = self.projNr + 1;
    self.catapult:setProjectile(proj);
    if self.currentProj.projCount > 0 then
        self.currentProj.projCount = self.currentProj.projCount - 1;
    end
end

function ps:unloadProjectile()
    if self.catapult.projectile ~= nil and self.currentProj ~= nil and self.currentProj.projCount >= 0 then
        self.currentProj.projCount = self.currentProj.projCount + 1;
    end
    self.catapult:removeProjectile();
end

function ps:loadLevel(level)
    if type(level.Statics) == 'table' then
        for id, bdata in pairs(level.Statics) do
            local bodyclass = require('Bodies/' .. bdata[1]);
            local body = bodyclass:new(bdata[2], bdata[3], bdata[4], bdata[5], bdata[6], bdata[7], bdata[8], bdata[9], bdata[10]);
            body.id = id;
            self.scene:addEntity(body);
        end
    end
    self.otdn = 0;
    if type(level.Bodies) == 'table' then
        for id, bdata in pairs(level.Bodies) do
            local bodyclass = require('Bodies/' .. bdata[1]);
            local body = bodyclass:new(bdata[2], bdata[3], bdata[4], bdata[5], bdata[6], bdata[7], bdata[8], bdata[9], bdata[10]);
            body.id = id;
            body.otd = true;
            self.scene:addEntity(body);
            self.otdn = self.otdn + 1;
        end
    end
    if type(level.Catapult) == 'table' then
        local catclass = require('Catapult');
        local cat = catclass:new(level.Catapult[1], level.Catapult[2], 'Catapult');
        self.scene:addEntity(cat);
        self.catapult = cat;
    end
    if type(level.Projectiles) == 'table' then
        self.Projectiles = {};
        local pn = 0;
        for class, count in pairs(level.Projectiles) do
--             print(class, count);
            local proj = { class = require('Bodies/' .. class), count = count };
            self.Projectiles[class] = proj;
            if level.defaultProjectile == class then
                self:setProjClass(proj.class);
            end
            pn = pn + 1;
        end
    end
    self.scene.topLimit = level.topLimit;
    self.scene.rightLimit = level.rightLimit;
    self.scene.bottomLimit = level.bottomLimit;
    self.scene.leftLimit = level.leftLimit;
    self.levelName = level.name;
end

function ps:finish()
end

return ps;
