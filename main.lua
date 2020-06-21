
PiroGame = require 'PiroGame/PiroGame';

Game = require('Game');

function love.load(args)
    game = Game:new(args);
end

function love.update(delta)
    game:update(delta);
end

function love.draw()
    game:draw();
end

function love.keypressed(key, code, isrepeat)
--     scene.eventManager:fireEvent(PiroGame.Input.KeyPressed:new(key, code, isrepeat))
--     print(key, code);
    game:keypressed(key, code, isrepeat);
end

function love.keyreleased(key)
--     scene.eventManager:fireEvent(PiroGame.Input.KeyReleased:new(key))
    game:keyreleased(key);
end

function love.mousepressed(x, y, button)
    game:mousepressed(x, y, button);
end

function love.mousereleased(x, y, button)
    game:mousereleased(x, y, button);
end

function love.mousemoved(x, y, dx, dy, touch)
    game:mousemoved(x, y, dx, dy, touch);
end

function love.wheelmoved(x, y)
    game:wheelmoved(x, y);
end

function love.resize(w, h)
    game:resize(w, h);
end
