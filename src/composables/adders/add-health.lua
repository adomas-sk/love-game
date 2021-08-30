-- config: {
--     max = number
--     initial = number
-- }
local function addHealth(c, config)
    c.health = {
        max = config.max,
        current = config.initial
    }

    local takeDamageHandler = function(damage)
        assert(damage ~= nil and damage >= 0, "damage is nil or less than zero")
        c.health.current = c.health.current - damage
        if c.health.current < 1 then
            c.eventEmitter:emitTo(c.id, "destroy")
        end
    end
    
    c:addEventHandler("takeDamage", takeDamageHandler)
end

return addHealth
