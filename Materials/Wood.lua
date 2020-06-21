
local material = {
    graphics = {
        texture = {
            file = 'Textures/wood.jpg',
            wrapx = 'mirroredrepeat',
            wrapy = 'mirroredrepeat',
            transforms = {
--                { mode = 'translate', x = 10, y = 10 },
                { mode = 'scale', x = 0.01, y = 0.01}
--                { mode = 'rotation', angle = 1 }
            }
        },
        destruction = {
            image = 'Textures/wood-bit.png',
            scale = {0.4, 0.4}
        }
    },
    physics = {
        shape = {
            mode = 'polygon'
        },
        friction = 1,
        density = 1,
        restitution = 0.5,
        hitThreshold = 100,
        breakThreshold = 350

    },
    audio = {
        onhit = {
            file = 'Sounds/wood-hit.wav'
        },
        ondestroy = {
            file = 'Sounds/hit.wav'
        }
    }
};

return material;
