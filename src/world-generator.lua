local forma = require("libs.forma")

local worldGenerator = {
  seed = 0,
  worldWidth = 10,
  worldHeight = 10,
  result = {},
}
local BLOCK_SIZE = 25

function worldGenerator.init(initialSeed)
  if initialSeed == nil or initialSeed == "" then
    initialSeed = math.random(999999)
  end
  worldGenerator.seed = initialSeed
  love.math.setRandomSeed(initialSeed)
end

function worldGenerator.generateWorld()
  local worldSquare = forma.primitives.square(worldGenerator.worldWidth, worldGenerator.worldHeight)
  local frequency, depth = 0.025, 1
  local thresholds = { 0, 0.455, 0.7 }

  local noise = forma.subpattern.perlin(worldSquare, frequency, depth, thresholds, love.math.random)

  -- forma.subpattern.print_patterns(worldSquare, noise, {".", "+", "o"})

  local colors = {
    {0.2, 0.3, 0.8, 1},
    {0.2, 0.8, 0.3, 1},
    {0.9, 0.9, 0.9, 1},
  }
  for k,pattern in pairs(noise) do
    for icell in pattern:cells() do
      worldGenerator.result[icell.x .. "-" .. icell.y] = {icell.x, icell.y, colors[k]}
    end
  end

  worldGenerator.blocksSetup()
end

local cols = 0
local rows = 0
local padding = 5
local leftBlock = 0
local topBlock = 0

local cellsToDraw = {}

function worldGenerator.blocksSetup()
  local screenW, screenH = love.graphics.getDimensions()

  cols = math.ceil(screenW / BLOCK_SIZE)
  rows = math.ceil(screenH / BLOCK_SIZE)
end

function worldGenerator.blocksUpdate()
  local centerX, centerY = Player.body:getPosition()

  local centerBlockX = math.ceil(centerX / BLOCK_SIZE)
  local centerBlockY = math.ceil(centerY / BLOCK_SIZE)

  local leftBlock = math.ceil(centerBlockX - cols / 2)
  local topBlock = math.ceil(centerBlockY - rows / 2)
  cellsToDraw = {}
  for x=-padding,cols + padding * 2 do
    for y=-padding,rows + padding * 2 do
      local cell = worldGenerator.result[leftBlock + x .. "-" .. topBlock + y]
      if cell then
        table.insert(cellsToDraw, cell)
      end
    end
  end
end

function worldGenerator.blocksDraw()
  -- TODO: do this in a canvas
  for _,v in pairs(cellsToDraw) do
    local x, y, color = unpack(v)
      love.graphics.setColor(unpack(color))
      love.graphics.rectangle(
        "fill",
        x * BLOCK_SIZE,
        y * BLOCK_SIZE,
        BLOCK_SIZE,
        BLOCK_SIZE
      )
  end

  return #cellsToDraw
end

return worldGenerator
