
local material = {
    graphics = {
        texture = {
            file = 'Textures/rock.jpg',
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
        breakThreshold = 500,
        shape = {
            mode = 'polygon'
        },
        friction = 0.5,
        density = 5,
        restitution = 0.3

    },
    audio = {
        --onhit = {
            --file = 'wood-hit.wav'
        --}
    }
};

return material;
