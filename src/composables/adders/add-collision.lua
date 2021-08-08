local function addCollision(c, colliderData)
  c.body = love.physics.newBody(c.world, colliderData.x, colliderData.y, colliderData.type)
  if colliderData.shape == "circle" then
    c.collider = love.physics.newCircleShape(colliderData.radius)
  else
    c.collider = love.physics.newRectangleShape(colliderData.w, colliderData.h)
  end
  c.fixture = love.physics.newFixture(c.body, c.collider)
  c.fixture:setUserData(c.id)
  c.shape = colliderData.shape

  local destroyHandler = function ()
    c.body:destroy()
    c.fixture:destroy()
  end

  c:addEventHandler("destroy", destroyHandler)
end

return addCollision
