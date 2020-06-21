

--[[local g = require 'Bodies/Ground';
local wb = require 'Bodies/WoodBlock';
local ct = require 'Catapult';

local pr = wb:new(0, 0, 0, 1, 1, "Projectile", "Extra!");
local cat = ct:new(100, 350, "Catapult");
cat:setProjectile(pr);

local s = {
    Bodies = {
        g:new(-100, 450, 0, 1, 1, 'Ground'),
        wb:new(500, 400, 1.57, 1, 1, 'Block1'),
        wb:new(575, 400, 1.57, 1, 1, 'Block2'),
        wb:new(540, 340, 0, 1, 1, 'Block3'),
        wb:new(650, 400, 1.57, 1, 1, 'Block4'),
        wb:new(725, 400, 1.57, 1, 1, 'Block5'),
        wb:new(680, 340, 0, 1, 1, 'Block6'),
        wb:new(575, 280, 1.57, 1, 1, 'Block7'),
--         wb:new(650, 280, 1.57, 1, 1, 'Block7'),
--         wb:new(630, 250, 0, 1, 1, 'Block7'),
        cat
    }
};]]

local s = {
    Name = "TestLevel 1",
    Statics = {},
    Bodies = {}
};

s.Statics['Ground'] = { 'Ground', -100, 450, 0, 1, 1 };
s.Bodies['Block1'] = { 'WoodBlock', 500, 400, 1.57, 1, 1 };
s.Bodies['Block2'] = { 'WoodBlock', 575, 400, 1.57, 1, 1 };
s.Bodies['Block3'] = { 'WoodBlock', 540, 340, 0, 1, 1 };
s.Bodies['Block4'] = { 'WoodBlock', 650, 400, 1.57, 1, 1 };
s.Bodies['Block5'] = { 'WoodBlock', 725, 400, 1.57, 1, 1 };
s.Bodies['Block6'] = { 'WoodBlock', 680, 340, 0, 1, 1 };
s.Bodies['Block7'] = { 'WoodBlock', 575, 280, 1.57, 1, 1 };

s.Catapult = { 100, 350 };

s.Projectiles = {};
s.Projectiles['WoodBlock'] = 20;
s.Projectiles['Stone'] = 5;

s.defaultProjectile = 'WoodBlock';

s.topLimit = -200;
s.rightLimit = 1500;
s.bottomLimit = 1000;
s.leftLimit = -200;

s.name = 'Testowy poziom.';

return s;
