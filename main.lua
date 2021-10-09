local camera = require("libs.camera")

local Composable = require("src.composables.composable")
local InputManagement = require("src.composables.input-management")
local EE = require("src.composables.event-emitter")
local worldGenerator = require("src.world-generatorv2")

local createCollisionHandler = require("src.composables.collision-handler")

local buildPlayer = require("src.composables.builders.player")

function love.mousepressed(x, y, button)
  Input:mousepressed(button)
end

function love.mousereleased(x, y, button)
  Input:mouserelease(button)
end

function love.keypressed(key)
  Input:keypressed(key)
end

function love.keyreleased(key)
  Input:keyrelease(key)
end

function love.load()
  local dispW, dispH = love.window.getDesktopDimensions()
  local screenW, screenH = dispW - 600, dispH-53-200
  love.window.setMode(screenW, screenH, { resizable = true, msaa = 5, vsync = false })
  worldGenerator.init(0)
  worldGenerator.generateWorld()
  Input = InputManagement.new()
  Input:addEventHandler("esc", "escape", function() love.event.quit(0) end)
  World = love.physics.newWorld(0, 0, true)
  EventEmitter = EE.new()
  Camera = camera.new(0, 0)
  createCollisionHandler(World, EventEmitter)
  Composable.init({
    world = World,
    input = Input,
    camera = Camera,
    eventEmitter = EventEmitter,
  })

  Player = Composable.new("player")
  buildPlayer(Player)

end

local timePassed = 0
function love.update(dt)
  World:update(dt)
  worldGenerator.blocksUpdate()
  EventEmitter:emit("update", dt)
  local x,y = Player.body:getPosition()
  Camera:lookAt(x,y)
  timePassed = timePassed + dt
end

function love.draw()
  Camera:attach()

  local renders = worldGenerator.blocksDraw()
  EventEmitter:emitDraw()

  Camera:detach()

  EventEmitter:emitDraw(true)
  love.graphics.print("TIME PASSED: " .. timePassed, 100, 0)
  love.graphics.print("blocks rendered: " .. renders, 0, 20)
end
