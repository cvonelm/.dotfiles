" This config uses vim plug for plugin management
call plug#begin()
" Language Server Protocol for error checking
Plug 'neovim/nvim-lspconfig'
" Stuff for autosuggestions 
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" Vimwiki for ... well ... a wiki
Plug 'vimwiki/vimwiki'
" Telescope for contextual search. brings up a big window in which you can 
" fuzzy find files, buffers, or file content
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Tree-sitter for syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()

" Use wayland clipboard. Useful for copying stuff to and fro browser windows
set clipboard=unnamedplus

" Display relative numbering on the left hand side. Makes jumping around with
" hjkl _much_ easier
set number
set relativenumber

" Magic to set a sane default for tab expansion, which is 4 spaces
" should (tm) be overwritten by editorconfig anyways
set shiftwidth=4
set tabstop=4
set softtabstop=-1
set expandtab
set smarttab
set t_Co=256

" foo is a dark theme
set background=dark
syntax enable
colorscheme foo

lua <<EOF
local cmp = require'cmp'

-- Modern programming language begins here
-- TODO: convert stuff further up to Lua

-- I prefer the block cursor
vim.opt.guicursor = ""

-- Use .editorconfig if present. This is an easy way to configure per-project
-- settings for indentation and stuff.
vim.g.editorconfig = true

-- Magic to get autosuggestions in a little list besides the cursor
vim.opt.completeopt = "menu,menuone,noselect"
cmp.setup({
	snippet = {
	expand = function(args)
	vim.snippet.expand(args.body)
	end,
	},
	window = {},
	mapping = cmp.mapping.preset.insert({}),
	sources = cmp.config.sources({{name = 'nvim_lsp'}})
})
cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })

-- Enable LSPs for
-- C/C++: clangd
-- Rust: rust_analyzer
-- Python: pyright
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['clangd'].setup {
	capabilities = capabilities
}
require('lspconfig').rust_analyzer.setup({})
require('lspconfig').pyright.setup({})


local telescope = require('telescope').setup({
defaults = {
    -- Dont want the preview pane
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

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
EOF

