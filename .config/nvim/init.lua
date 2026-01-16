vim.pack.add({
    "https://github.com/vimwiki/vimwiki"}
)
vim.pack.add({"https://github.com/nvim-treesitter/nvim-treesitter"})
vim.pack.add({"https://github.com/nvim-lua/plenary.nvim"})
vim.pack.add({"https://github.com/nvim-telescope/telescope.nvim"})
vim.pack.add({"https://github.com/EdenEast/nightfox.nvim"})
vim.pack.add({"https://github.com/neovim/nvim-lspconfig"})
vim.pack.add({"https://github.com/hrsh7th/cmp-nvim-lsp"})
vim.pack.add({"https://github.com/hrsh7th/cmp-buffer"})
vim.pack.add({"https://github.com/hrsh7th/cmp-path"})
vim.pack.add({"https://github.com/hrsh7th/cmp-cmdline"})
vim.pack.add({"https://github.com/hrsh7th/nvim-cmp"})
vim.pack.add({"https://github.com/jmbuhr/otter.nvim"})
vim.pack.add({"https://github.com/quarto-dev/quarto-nvim"})

vim.opt.background = "light"
vim.cmd [[colorscheme  dayfox]]

vim.opt.clipboard = "unnamedplus"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.smarttab = true
vim.opt.swapfile = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- I prefer the block cursor
vim.opt.guicursor = ""

-- Use .editorconfig if present. This is an easy way to configure per-project
-- settings for indentation and stuff.
vim.g.editorconfig = true

-- Magic to get autosuggestions in a little list besides the cursor
vim.opt.completeopt = "menu,menuone,noselect"

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

require'nvim-treesitter'.setup {}

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

        vim.g.vimwiki_list = {
            {
            path = '~/vimwiki',
            syntax = 'markdown',
            ext = '.md',
            },
        }
vim.lsp.config('clangd', {})
vim.lsp.enable('clangd')
vim.lsp.config('rust_analyzer', {})
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('basedpyright')
vim.lsp.config('texlab', {})
vim.lsp.enable('texlab')
vim.lsp.enable('cmake')

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


require'nvim-treesitter'.install { 'rust', 'cpp', 'python'}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

require'otter'.setup{}

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
