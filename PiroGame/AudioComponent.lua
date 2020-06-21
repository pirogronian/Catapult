
local args = ...;

local ac = args.PiroGame.class('AudioComponent', args.PiroGame.Component);

function ac:initialize(file, t, id)
    args.PiroGame.Component.initialize(self, id);
    self.file = file;
    self.type = t;
end

function ac:activate()
--    print('AudioComponent', self, self.id, 'activation. For', self.entity, self.entity.id);
    if (self.file ~= nil) then
        self.source = love.audio.newSource(self.file, self.type);
--        print('Created source:', self.source, '(', type(self.source), ')');
    end
end

function ac:deactivate()
    self.source = nil;
end

function ac:play()
    if self.source ~= nil then
        self.source:play();
    end
end

return ac;
