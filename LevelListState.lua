
local pg = require('PiroGame/PiroGame');
local gs = require('GameState');

local lls = pg.class('LevelListState', gs);

function lls:initialize(game)
    gs.initialize(self, game);
    self.levels = {};
    local files = love.filesystem.getDirectoryItems("Levels");
    for k, fname in pairs(files) do
        local file, err = loadfile ("Levels/" .. fname);
        if err == nil then
            table.insert(self.levels, file());
        end
    end
end

function lls:update(dt)
    local slab = self.game.slab;
    slab.BeginWindow("LLW");
    slab.Text("Levels");
    if (slab.Button("Back to main menu")) then
        self.game:switchState("MainMenuState");
    end
    for k, v in ipairs(self.levels) do
        local name = v.Name;
        if name == nil then
            name = k;
        end
        if slab.Button(name) then
            self.game.level = v;
            self.game:switchState("PlayState");
        end
    end
    slab.EndWindow();
end

function lls:resize(w, h)
end

return lls;
