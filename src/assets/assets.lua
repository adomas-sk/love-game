local assets = {}

assets.images = {
  walk = {
    animations = {
      walk = {
        {0, 0, 480, 480},
        { 480,  0,  480 * 2, 480 },
        { 480 * 2,  0,  480 * 3, 480 },
        { 480 * 3,  0,  480 * 4, 480 },
        { 480 * 4,  0,  480 * 5, 480 },
      }
    },
    src = "src/assets/images/walk.png"
  }
}

return assets
