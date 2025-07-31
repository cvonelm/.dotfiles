" This config uses vim plug for plugin management
call plug#begin()
" Stuff for autosuggestions 
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Vimwiki for ... well ... a wiki
Plug 'vimwiki/vimwiki'
" Telescope for contextual search. brings up a big window in which you can 
" fuzzy find files, buffers, or file content
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

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

let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': 'md'}]
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
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
EOF

