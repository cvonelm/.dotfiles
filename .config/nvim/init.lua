-- This makes use of vim.pack, which is as of january 2026
-- not in a neovim release, so this requires neovim from git

-- better code parsing -> better highlighting
vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter"})
-- a library of helpers. Used by telescope
vim.pack.add({"https://github.com/nvim-lua/plenary.nvim"})
-- a pop up fuzzy-finder window provider
-- provides (fuzzy) search for files, buffers and in files
vim.pack.add({"https://github.com/nvim-telescope/telescope.nvim"})
-- dayfox from nightfox is my curren theme
vim.pack.add({"https://github.com/EdenEast/nightfox.nvim"})
-- ready-made LSP configs for every language one can ever need
vim.pack.add({"https://github.com/neovim/nvim-lspconfig"})
-- nvim autocompletion
-- TODO is this still needed? vim.cmp exists
vim.pack.add({"https://github.com/hrsh7th/cmp-nvim-lsp"})
vim.pack.add({"https://github.com/hrsh7th/cmp-buffer"})
vim.pack.add({"https://github.com/hrsh7th/cmp-path"})
vim.pack.add({"https://github.com/hrsh7th/cmp-cmdline"})
vim.pack.add({"https://github.com/hrsh7th/nvim-cmp"})
-- highlighting and all the shebang for markdown code blocks
vim.pack.add({"https://github.com/jmbuhr/otter.nvim"})
-- support for the coolest way of interactively writing data
-- analysis and text.
vim.pack.add({"https://github.com/quarto-dev/quarto-nvim"})

-- light colourscheme all the way
vim.opt.background = "light"
vim.cmd [[colorscheme  dayfox]]

-- use system clipboard for vim
-- allows y -> Ctrl-V in firefox and back
vim.opt.clipboard = "unnamedplus"

-- number the lines on the left of the buffer
vim.opt.number = true
-- use relative numbering. Makes commands that take numbers of 
-- lines _much_ easier
vim.opt.relativenumber = true

-- Make Tab -> 4 spaces work correctly
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Don't record a swapfile.
vim.opt.swapfile = false

-- I prefer the block cursor
vim.opt.guicursor = ""

-- Use .editorconfig if present. This is an easy way to configure per-project
-- settings for indentation and stuff.
vim.g.editorconfig = true

-- Magic to get autosuggestions in a little list besides the cursor
vim.opt.completeopt = "menu,menuone,noselect"

-- Get diagnostics (aka, "foobar.h not used"), but only for the currently selected line
vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

local telescope = require('telescope').setup({
defaults = {
    -- Dont want a separate pane with a preview
	preview = false,
	preview = {
		hide_on_startup = true
	},
    -- folders containing build files and submodules, respectively
    -- pollutes the search output, so filter
    file_ignore_patterns = { "build", "libs" }
}})

local builtin = require('telescope.builtin')
-- /ff -> find in file names
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- /fg -> fine in file content
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- /fb -> find in open buffer names
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

-- clangd, for C,C++
vim.lsp.config('clangd', {})
vim.lsp.enable('clangd')
-- Rust
vim.lsp.config('rust_analyzer', {})
vim.lsp.enable('rust_analyzer')
-- Python
vim.lsp.enable('basedpyright')
-- Texlab
vim.lsp.config('texlab', {})
vim.lsp.enable('texlab')
-- R language R server
-- requires
-- install.packages("languageserver")
vim.lsp.enable('r_language_server')
-- cmake-language-server is currently broken with
-- modern Pythons :(
--vim.lsp.enable('cmake')

-- set up autocomplete
local cmp = require'cmp' 
cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    -- autocomplete with enter to insert and Tab to cycle
    -- through selections
    -- TODO make entering a Tab less of a hassle
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
})

-- Give treesitter the beans
require'nvim-treesitter'.setup {}
require'nvim-treesitter'.install { 'rust', 'cpp', 'python', 'javascript', 'cmake' }

-- Hook treesitter to the filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cpp' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cmake' },
  callback = function() vim.treesitter.start() end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust' },
  callback = function() vim.treesitter.start() end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'rust' },
  callback = function() vim.treesitter.start() end,
})

require'otter'.setup{}

-- Default quarto config from their README
require('quarto').setup{
  debug = false,
  closePreviewOnExit = true,
  lspFeatures = {
    enabled = true,
    chunks = "curly",
    languages = { "r", "python", "julia", "bash", "html" },
    diagnostics = {
      enabled = true,
      triggers = { "BufWritePost" },
    },
    completion = {
      enabled = true,
    },
  },
  codeRunner = {
    enabled = true,
    default_method = "slime", -- "molten", "slime", "iron" or <function>
    ft_runners = {}, -- filetype to runner, ie. `{ python = "molten" }`.
    -- Takes precedence over `default_method`
    never_run = { 'yaml' }, -- filetypes which are never sent to a code runner
  },
}
