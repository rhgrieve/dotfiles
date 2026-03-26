local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.uv.fs_stat(lazypath) then
  print('Installing lazy.nvim....')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
  print('Done.')
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '

-- lazy initialization
require('lazy').setup({
  {'folke/tokyonight.nvim'},
  {'neovim/nvim-lspconfig'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/nvim-cmp'},
  {
    'nvimdev/dashboard-nvim', 
    event = 'VimEnter', 
    dependencies = { 
      {'nvim-tree/nvim-web-devicons'},
    }
  },
  {
    'nvim-tree/nvim-tree.lua', 
    dependencies = {
      {'nvim-tree/nvim-web-devicons'},
    }
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'lua', 'rust', 'javascript', 'typescript', 'astro', 'css', 'html', 'markdown', 'json', 'yaml', 'toml' },
      highlight = { enable = true },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      {'nvim-tree/nvim-web-devicons'}
    },
  },
  {
    'renerocksai/telekasten.nvim',
    dependencies = {
      {'nvim-telescope/telescope.nvim'},
      {'nvim-telekasten/calendar-vim'},
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      {'nvim-lua/plenary.nvim'},
    },
  },
})

-- lsp config (native vim.lsp.config, nvim 0.11+)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local opts = {buffer = event.buf}

    -- K (hover), grn (rename), grr (references), gra (code action),
    -- gri (implementation) are built-in defaults in 0.11+
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
  end,
})

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

vim.lsp.enable({'lua_ls', 'rust_analyzer'})

local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp.mapping(function()
      if vim.snippet.active({direction = 1}) then vim.snippet.jump(1) end
    end, {'i', 's'}),
    ['<C-b>'] = cmp.mapping(function()
      if vim.snippet.active({direction = -1}) then vim.snippet.jump(-1) end
    end, {'i', 's'}),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

-- telescope keybinds
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

require('telekasten').setup({
  home = vim.fn.expand("~/Notes"),
})

-- Launch panel if nothing is typed after <leader>z
vim.keymap.set("n", "<leader>z", "<cmd>Telekasten panel<CR>")

-- Most used functions
vim.keymap.set("n", "<leader>zf", "<cmd>Telekasten find_notes<CR>")
vim.keymap.set("n", "<leader>zg", "<cmd>Telekasten search_notes<CR>")
vim.keymap.set("n", "<leader>zd", "<cmd>Telekasten goto_today<CR>")
vim.keymap.set("n", "<leader>zz", "<cmd>Telekasten follow_link<CR>")
vim.keymap.set("n", "<leader>zn", "<cmd>Telekasten new_note<CR>")
vim.keymap.set("n", "<leader>zc", "<cmd>Telekasten show_calendar<CR>")
vim.keymap.set("n", "<leader>zb", "<cmd>Telekasten show_backlinks<CR>")
vim.keymap.set("n", "<leader>zI", "<cmd>Telekasten insert_img_link<CR>")

-- Call insert link automatically when we start typing a link
vim.keymap.set("i", "[[", "<cmd>Telekasten insert_link<CR>")

require('nvim-tree').setup()
require('lualine').setup()

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>')

-- vim settings
vim.wo.number = true
vim.cmd('colorscheme tokyonight')
vim.o.exrc = true

