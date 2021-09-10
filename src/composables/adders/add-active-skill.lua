local vector = require("libs.vector")

-- config: {
--   id = string,
--   speed = number,
--   createCastHandler = function,
-- }
local function addActiveSkill(c, key, config)
  if not c.skills then
    c.skills = {}
  end

  assert(c.skills[config.id] == nil, "addActiveSkill: skill added to composable")

  c.skills[config.id] = {
    speed = config.speed,
  }
  local getSource = function ()
    return vector(c.body:getPosition())
  end
  c.input:addEventHandler(config.id, key, config.createCastHandler({
    getSource = getSource,
    offset = c.collider:getRadius(),
    maxLifeSpan = 2,
  }))
end

return addActiveSkill
