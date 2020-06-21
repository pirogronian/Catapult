
local material = {
    graphics = {
        texture = {
            file = 'Textures/soil.jpg',
            wrapx = 'repeat',
            wrapy = 'repeat',
            transforms = {
--                { mode = 'translate', x = 10, y = 10 },
                { mode = 'scale', x = 0.005, y = 0.005}
--                { mode = 'rotation', angle = 1 }
            }
        }
    },
    physics = {
        hitThreshold = 15,
        breakThreshold = false,
        shape = {
            mode = 'polygon'
        },
        friction = 5,
        density = 2,
        restitution = 0.1

    },
    audio = {
        --onhit = {
            --file = 'wood-hit.wav'
        --}
    }
};

return material;
