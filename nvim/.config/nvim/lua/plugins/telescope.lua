return {
  'nvim-telescope/telescope.nvim', tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    -- change a key map to browse project files
    {'<leader>pf', '<cmd>Telescope find_files<cr>', desc= 'Find files' },

    -- Browse git files only
    {'<C-p>', '<cmd>Telescope git_files<cr>', desc= 'Find git repo files' },

    -- Grep project files
    {
      '<leader>ps',
      function() 
        require('telescope.builtin').grep_string({search = vim.fn.input("Grep > ") }) 
      end,
      desc= 'Grep files'
    },
    }
}
