local vector = require("libs.vector")

-- config: {
--     target = string,
--     minDistance = number,
--     skill = skill
-- }
local function addHostileBehaviour(c, config)
    assert(c.body ~= nil, "Tried to add hostile behaviour to composable without body")

    c.hostileBehaviour = {
    }

    local target = c.eventEmitter:getComposable(config.target)

    local checkTicks = 0
    local hostilityTicks = 0
    local updateHandler = function()
        if target == nil then
            if checkTicks == 10 then
                target = c.eventEmitter:getComposable(config.target)
                checkTicks = 0
            end
            checkTicks = checkTicks + 1
        end
        local targetPos = vector(target.body:getPosition())
        local position = vector(c.body:getPosition())
        local distance = targetPos:dist(position)
        if distance < config.minDistance then
            if hostilityTicks == config.skill.speed then
                config.skill.castHandler()
                hostilityTicks = 0
            end
            hostilityTicks = hostilityTicks + 1
        else
            hostilityTicks = 0
        end
    end
    c:addEventHandler("update", updateHandler)
end

return addHostileBehaviour
