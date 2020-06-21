
local debug = {}; 

function debug.dumpTable(t)
    for k, v in pairs(t) do
        print(string.format('[(%s) %s] = (%s) %s', type(k), k, type(v), v));
    end
end

return debug;
