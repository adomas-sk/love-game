-- local gamera = require("libs.gamera")
local camera = require("libs.camera")
local HC = require("libs.HC")

local Composable = require("src.composables.composable")
local InputManagement = require("src.composables.input-management")
local EE = require("src.composables.event-emitter")

local addPlayerControl = require("src.composables.adders.add-player-control")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")

function love.load()
  Input = InputManagement.new()
  EventEmitter = EE.new()
  World = love.physics.newWorld(0, 200, true)
  Camera = camera.new(0,0)
  WorldCollider = HC.new()
  Composable.init({
    input = Input,
    camera = Camera,
    worldCollider = WorldCollider,
    eventEmitter = EventEmitter,
  })

  Player = Composable.new("player")
  addCollision(Player, {
    x = 400,
    y = 200,
    radius = 50,
    shape = "circle",
  })
  addSprite(Player, {
    radius = 50
  })
  addPlayerControl(Player)

  local static = Composable.new("static")
  addCollision(static, {
    x = 400,
    y = 400,
    w = 200,
    h = 50,
    shape = "rectangle",
  })
  addSprite(static, {
    x = 400,
    y = 400,
    w = 200,
    h = 50,
  })

  -- static = {}
  -- static.collider = WorldCollider:rectangle(400, 400, 200, 50)
end

function love.update(dt)
  World:update(dt)
  EventEmitter:emit("update")
  Camera:lookAt(Player.position:unpack())
end

function love.draw()
  Camera:attach()
  EventEmitter:emit("draw")
  Camera:detach()
  -- Camera:move(Player.position:unpack())
  -- Camera:draw(function ()
    -- local staticCX, staticCY = static.collider:center()
    -- love.graphics.rectangle("line", staticCX - 100, staticCY - 25, 200, 50)
  -- end)
end

function love.mousepressed(x, y, button)
  Input:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  Input:mouserelease(x, y, button)
end

function love.keypressed(key)
  Input:keypressed(key)
end

function love.keyreleased(key)
  Input:keyrelease(key)
end
