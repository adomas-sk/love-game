local vector = require("libs/vector")

local Composable = require("src.composables.composable")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")
local addGetInProximityBehaviour = require("src.composables.adders.add-get-in-proximity-behaviour")
local addHealth = require("src.composables.adders.add-health")

-- config = {
--   initialCoords = {x,y}
-- }
local robotTasks = {
  findBuilding = "findBuilding",
  findPlayer = "findPlayer"
}
local robotCount = 0
local function buildRobot(config)
  local currentTask = robotTasks.findBuilding
  local robotId = "robot" .. robotCount
  local robot = Composable.new(robotId)
  addCollision(robot, {
    x = config.initialCoords[1],
    y = config.initialCoords[2],
    radius = 20,
    shape = "circle",
    type = "dynamic",
    fixtureData = {
      dmgBy = "enemy"
    },
    categories = {"robot"},
    masks = {"playerProjectile", "wall", "player", "enemy"}
  })
  addSprite(robot, {
    drawPosition = 6,
    radius = 20,
    color = {1, 0, 1, 1,}
  })
  local getDestination = function ()
    if currentTask == robotTasks.findBuilding then
      local buildings = EventEmitter:getComposables("building")
      local closestDistance = 1000000000
      local closestBuilding = nil
      for k,v in pairs(buildings) do
        local distance = vector(v.body:getPosition()):dist(vector(robot.body:getPosition()))
        if distance <= 50 then
          currentTask = robotTasks.findPlayer
        end
        if distance < closestDistance then
          closestDistance = distance
          closestBuilding = v
        end
      end
      if closestBuilding ~= nil then
        return vector(closestBuilding.body:getPosition())
      end
    elseif currentTask == robotTasks.findPlayer then
      local player = EventEmitter:getComposable("player")
      if player ~= nil then
        local distance = vector(player.body:getPosition()):dist(vector(robot.body:getPosition()))
        if distance <= 50 then
          currentTask = robotTasks.findBuilding
        end
        return vector(player.body:getPosition())
      end
    end
    return nil
  end
  addGetInProximityBehaviour(robot, {
    speed = 100,
    minDistance = 50,
    getDestination = getDestination,
  })
  local deathCallback = function()
    print("Robot ded")
  end
  addHealth(robot, {
    max = 10,
    initial = 10,
    deathCallback = deathCallback,
  })
  robotCount = robotCount + 1
  return robot
end

return buildRobot