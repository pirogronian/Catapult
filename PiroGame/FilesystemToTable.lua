
local function ftt(dir)
    local ns = {};

    items = love.filesystem.getDirectoryItems(dir);

    for _, i in pairs(items) do
        if love.filesystem.isDirectory(i) then
--             print('Directory:', i);
            ns[i] = ftt(i);
        else
            if i:match('lua$') then
--                 print('Lua file:', i);
                ns[i] = (assert(loadfile(i)))();
            end
        end
    end
    
    return ns;
end

return ftt;
