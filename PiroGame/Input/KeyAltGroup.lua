
args = ...;

local kg = args.PiroGame.class('KeyAltGroup');

function kg:initialize(keys)
    self.keys = {};
    if keys ~= nil then
        if type(keys) == 'string' or (type(keys) == 'table' and type(keys.isDown) == 'function') then
            self:addKey(keys);
        else
            self:addKeys(keys);
        end
    end
end

function kg:addKey(key)
    self.keys[key] = true;
end

function kg:addKeys(keys)
    for _, key in pairs(keys) do
        self:addKey(key);
    end
end

function kg:removeKey(key)
    self.keys[key] = nil;
end

function kg:clear()
    self.keys = {};
end

function kg:isDown()
    for key, val in pairs(self.keys) do
        if (val == true) then
            if (type(key) == 'string' and love.keyboard.isDown(key) == true) or (type(key.isDown) == 'function' and key:isDown()) then
                return true;
            end
        end
    end
    return false;
end

return kg;
