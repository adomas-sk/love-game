-- colliderData = {
--   x = number,
--   y = number,
--   type = "circle" | "rectangle",
--   radius = number,
--   w = number,
--   h = number,
--   fixtureData = {}
--   categories = categories[]
--   masks = categories[]
-- }
local categories = {
  player = 1,
  enemy = 2,
  playerProjectile = 3,
  enemyProjectile = 4,
  wall = 5,
  robot = 6,
  building = 6,
}
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

  if colliderData.categories then
    local shapeCategories = {}
    for _,v in ipairs(colliderData.categories) do
      local category = categories[v]
      assert(category ~= nil, "addCollision: category not found - " .. v)
      table.insert(shapeCategories, category)
    end
    c.fixture:setCategory(unpack(shapeCategories))
  end
  if colliderData.masks then
    local shapeMasks = {}
    for _,v in ipairs(colliderData.masks) do
      local mask = categories[v]
      assert(mask ~= nil, "addCollision: mask not found - " .. v)
      table.insert(shapeMasks, mask)
    end
    c.fixture:setMask(unpack(shapeMasks))
  end

  local destroyHandler = function ()
    c.fixture:destroy()
    c.body:destroy()
  end

  c:addEventHandler("destroy", destroyHandler)
end

return addCollision
