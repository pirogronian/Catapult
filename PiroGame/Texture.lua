
local args = ...;

local texture = {};

function texture.meshUVFromGeometry(mesh)
    local verts = {};
    for i, v in pairs(mesh) do
        v[3] = v[1];
        v[4] = v[2];
        verts[i] = v;
    end
    
    return verts;
end

function texture.meshUVTranslate(mesh, x, y)
    local verts = {};
    for i, v in pairs(mesh) do
        v[3] = v[3] + x;
        v[4] = v[4] + y;
        verts[i] = v;
    end

    return verts;
end

function texture.meshUVScale(mesh, s)
    local verts = {};
    for i, v in pairs(mesh) do
        v[3] = v[3] * s;
        v[4] = v[4] * s;
        verts[i] = v;
    end

    return verts;
end

function texture.meshUVRotate(mesh, angle)
    local verts = {};
    for i, v in pairs(mesh) do
        v[3] = v[3] * math.cos(angle) - v[4] * math.sin(angle);
        v[4] = v[3] * math.sin(angle) + v[4] * math.cos(angle);
        verts[i] = v;
    end

    return verts;
end

return texture;
