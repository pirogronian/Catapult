
local args = ...;

local KeySequence = args.PiroGame.class('KeySequence');

local debug = require('Debug');

function KeySequence:clear()
    self._pressedKeys = {};
    self._pressedCount = 0;
    self._neededCount = 0;
    self.active = false;
end

function KeySequence:initialize(arg, eventManager)
    self.eventManager = eventManager;
    self:clear();
    if type(arg) == 'string' then
        self:addKey(arg);
    else
        if type(arg) == 'table' then
            for _, key in pairs(arg) do
                self:addKey(key);
            end
        end
    end
end

function KeySequence:startListen(eventManager)
    if eventManager == nil then
        eventManager = self.eventManager;
    end
    eventManager:addListener('KeyPressed', self, self.keyDown);
    eventManager:addListener('KeyReleased', self, self.keyUp);
    
end

function KeySequence:stopListen(eventManager)
    if eventManager == nil then
        eventManager = self.eventManager;
    end
    eventManager:removeListener('KeyPressed', self);
    eventManager:removeListener('KeyReleased', self);
    for key, val in pairs(self._pressedKeys) do
        self._pressedKeys[key] = false;
    end
    self._pressedCount = 0;
end

function KeySequence:addKey(key)
    self._pressedKeys[key] = false;
    self._neededCount = self._neededCount + 1;
end

function KeySequence:delKey(key)
    if (self._pressedKeys[key] ~= nil) then
        self._neededCount = self._neededCount - 1;
        self._pressedKeys[key] = nil;
    end
end

function KeySequence:setCode(code)
    self.code = code;
end

function KeySequence:keyDown(event)
    key = event.key;
--     print(string.format('KeySequence:keyDown(%s), pressed count %u', key, self._pressedCount));
    if (self._pressedKeys[key] ~= nil) then
--         print('Registered key pressed');
        self._pressedKeys[key] = true;
        self._pressedCount = self._pressedCount + 1;
    end
    code = event.code;
    if (self._pressedCount == self._neededCount or self.code == code) then
        self.active = true;
        if (type(self.activated) == 'function') then
            self:activated()
        end
    end
end

function KeySequence:keyUp(event)
    key = event.key;
--     print(string.format('KeySequence:keyUp(%s), pressed count: %u', key, self._pressedCount));
    if (self._pressedKeys[key] == true) then
--         print('Registered key released');
        self._pressedKeys[key] = false;
        if (self._pressedCount == self._neededCount) then
            self.active = false;
            if (type(self.deactivated) == 'function') then
                self:deactivated()
            end
        end
        if (self._pressedCount > 0) then
            self._pressedCount = self._pressedCount - 1;
        end
    end
end

return KeySequence;
