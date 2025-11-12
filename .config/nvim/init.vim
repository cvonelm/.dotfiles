" This config uses vim plug for plugin management
call plug#begin()
" Stuff for autosuggestions 
" Vimwiki for ... well ... a wiki
Plug 'vimwiki/vimwiki'
" Telescope for contextual search. brings up a big window in which you can 
" fuzzy find files, buffers, or file content
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'EdenEast/nightfox.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
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
set noswapfile
set smarttab
set t_Co=256

set background=light
syntax enable
colorscheme dayfox

let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': 'md'}]

lua <<EOF
-- Modern programming language begins here
-- TODO: convert stuff further up to Lua

-- I prefer the block cursor
vim.opt.guicursor = ""

-- Use .editorconfig if present. This is an easy way to configure per-project
-- settings for indentation and stuff.
vim.g.editorconfig = true

-- Magic to get autosuggestions in a little list besides the cursor
vim.opt.completeopt = "menu,menuone,noselect"

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

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

vim.lsp.config('clangd', {})
vim.lsp.enable('clangd')

local builtin = require('telescope.builtin')
-- /ff -> find in file names
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- /fg -> fine in file content
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
-- /fb -> find in open buffer names
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})

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
EOF

