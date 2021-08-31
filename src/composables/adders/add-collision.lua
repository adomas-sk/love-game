-- colliderData = {
--   x = number,
--   y = number,
--   type = "circle" | "rectangle",
--   radius = number,
--   w = number,
--   h = number,
--   fixtureData = {}
-- }
local function addCollision(c, colliderData)
  c.body = love.physics.newBody(c.world, colliderData.x, colliderData.y, colliderData.type)
  if colliderData.shape == "circle" then
    c.collider = love.physics.newCircleShape(colliderData.radius)
  else
    c.collider = love.physics.newRectangleShape(colliderData.w, colliderData.h)
  end
  c.fixture = love.physics.newFixture(c.body, c.collider)
  local userData = {
    id = c.id
  }

  if colliderData.fixtureData ~= nil then
    for k,v in pairs(colliderData.fixtureData) do
      userData[k] = v
    end
  end
  c.fixture:setUserData(userData)
  c.shape = colliderData.shape

  local destroyHandler = function ()
    c.fixture:destroy()
    c.body:destroy()
  end

  c:addEventHandler("destroy", destroyHandler)
end

return addCollision
