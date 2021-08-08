-- config: {
--   id = string,
--   speed = number,
--   castHandler = function,
-- }
local function addActiveSkill(c, key, config)
  if not c.skills then
    c.skills = {}
  end

  c.skills[config.id] = {
    speed = config.speed,
  }
  c.input:addEventHandler(config.id, key, config.castHandler)
end

return addActiveSkill
