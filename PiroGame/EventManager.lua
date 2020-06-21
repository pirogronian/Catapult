
local args = ...;

local EventManager = args.PiroGame.class("EventManager")

function EventManager:initialize()
    self.eventListeners = {}
end

-- Adding an eventlistener to a specific event
function EventManager:addListener(eventName, listener, listenerFunction)
    -- If there's no list for this event, we create a new one
    if not self.eventListeners[eventName] then
        self.eventListeners[eventName] = {}
    end

    if not listener.class or (listener.class and not listener.class.name) then
        print('Eventmanager: The listener has to implement a listener.class.name field.')
    end

--[[     for _, registeredListener in pairs(self.eventListeners[eventName]) do
        if registeredListener[1].class == listener.class then
            print(
                string.format("Eventmanager: EventListener for {%s} already exists.", eventName))
            return
        end
    end]]
    if type(listenerFunction) == 'function' then
        self.eventListeners[eventName][listener] = listenerFunction;
    else
        print('Eventmanager: Third parameter has to be a function! Please check listener for ' .. eventName)
        if listener.class and listener.class.name then
            print('Eventmanager: Listener class name: ' .. listener.class.name)
        end
    end
end

-- Removing an eventlistener from an event
function EventManager:removeListener(eventName, listener)
    if self.eventListeners[eventName] then
        if self.eventListeners[eventName][listener] then
            self.eventListeners[eventName][listener] = nil;
        else
            print(string.format("Eventmanager: Listener %s to be deleted on Event %s is not existing.", listener.class.name, eventName))
        end
    else
        print(string.format("Eventmanager: Event %s listener should be removed from is not existing ", eventName));
    end
end

-- Firing an event. All registered listener will react to this event
function EventManager:fireEvent(event)
    local name = event.class.name
    if self.eventListeners[name] then
        for listener, method in pairs(self.eventListeners[name]) do
            method(listener, event);
        end
    end
end

return EventManager
