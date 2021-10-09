local assets = {}

assets.images = {
  char = {
    walk = {
      src = "src/assets/images/char-walk/char-walk.png",
      normal = "src/assets/images/char-walk/char-walk_normal.png",
      data = "src/assets/images/char-walk/char-walk_data",
      directions = {
        ["walk-sd"] = { range = {"1-15", 1}, speed = 0.1, rot = 0.5 },
        ["walk-sw"] = { range = {"1-15", 2}, speed = 0.1,  rot = 0.75 },
        ["walk-wd"] = { range = {"1-15", 3}, speed = 0.1, rot = 1 },
        ["walk-nw"] = { range = {"1-15", 4}, speed = 0.1,  rot = -0.75 },
        ["walk-nd"] = { range = {"1-15", 5}, speed = 0.1, rot = -0.5 },
        ["walk-ne"] = { range = {"1-15", 6}, speed = 0.1,  rot = -0.25 },
        ["walk-ed"] = { range = {"1-15", 7}, speed = 0.1, rot = 0 },
        ["walk-se"] = { range = {"1-15", 8}, speed = 0.1,  rot = 0.25 },
      }
    }
  },
}

return assets
