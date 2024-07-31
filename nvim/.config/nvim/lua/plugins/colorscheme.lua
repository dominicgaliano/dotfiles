return { 
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false, -- make sure to load during startup
  priority = 1000, -- load before all other plugins
  config = function()
    local rosepine = require("rose-pine")
    rosepine.setup({
      variant = 'auto',
      -- disable_background = true,
      -- disable_float_background = true,
    })
    vim.cmd('colorscheme rose-pine')
    end,
}
