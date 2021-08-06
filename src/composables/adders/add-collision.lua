local vector = require("../../../libs/vector")

local function addCollision(c, colliderData)
  if colliderData.shape == "circle" then
    c.collider = c.worldCollider:circle(colliderData.x, colliderData.y, colliderData.radius)
  else
    c.collider = c.worldCollider:rectangle(colliderData.x, colliderData.y, colliderData.w, colliderData.h)
  end
  c.shape = colliderData.shape
  c.position = vector(colliderData.x, colliderData.y)

  local updateHandler = function()
    c.collider:moveTo(c.position:unpack())
    for shape, delta in pairs(c.worldCollider:collisions(c.collider)) do
      c.eventEmitter:emitTo(c.id, "collide", { shape = shape, delta = delta })
    end
  end

  c:addEventHandler("update", updateHandler)
end

return addCollision
