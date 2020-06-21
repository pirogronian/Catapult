
local meshToPolygon = function (meshverts)
    pol = {};
    
    for _, v in pairs(meshverts) do
        table.insert(pol, v[1]);
        table.insert(pol, v[2]);
    end
    
    return pol;
end

return meshToPolygon;
 
