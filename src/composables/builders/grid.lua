local Composable = require("src.composables.composable")
local addSprite = require("src.composables.adders.add-sprite")
local addCollision = require("src.composables.adders.add-collision")

local blockCount = 0
-- grid: {rows}{columns}
local function buildGrid(grid)
  if grid == nil then
    grid = {
      {"-",".",".",".","-"},
      {"-",".",".",".","-"},
      {"-",".",".",".","-"},
      {"-",".",".",".","-"},
      {"-","-","-","-","-"}
    }
  end
  local BLOCK_SIZE = 50
  for rowIndex,row in ipairs(grid) do
    for colIndex,col in ipairs(row) do
      if col == "-" then
        local block = Composable.new("block" .. blockCount)
        addCollision(block, {
          y = (rowIndex - 1) * BLOCK_SIZE,
          x = (colIndex - 1) * BLOCK_SIZE,
          w = BLOCK_SIZE,
          h = BLOCK_SIZE,
          type = "static",
          shape = "rectangle",
          categories = {"wall"}
        })
        addSprite(block, {
          drawPosition = 3,
          w = BLOCK_SIZE,
          h = BLOCK_SIZE,
          color = {0, 1, 0.5, 1,}
        })

        blockCount = blockCount + 1
      end
    end
  end
end

return buildGrid
