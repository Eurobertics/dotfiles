-- Leader Key (muss vor Plugins definiert werden)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basis Optionen
vim.opt.number = true		-- Zeilennummern
vim.opt.relativenumber = true	-- Relative Zeilennummer
vim.opt.tabstop = 4		-- Tab = 4 Spaces
vim.opt.shiftwidth = 4		-- Einrückung = 4 Spaces
vim.opt.expandtab = true	-- Tabs zu Spaces konvertieren
vim.opt.smartindent = true	-- Automatisches Einrücken
vim.opt.wrap = false		-- Kein Zeilenumbruch
vim.opt.termguicolors = true	-- Volle Farbunterstützung
-- vim.opt.mouse = ""  -- Maus komplett deaktivieren

-- lazy.nvim Bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
-- Colorscheme
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm",
    })
    vim.cmd("colorscheme tokyonight-storm")
  end,
},

-- Syntax Highlighting
{
  "nvim-treesitter/nvim-treesitter",
  commit = "7caec274fd19c12b55902a5b795100d21531391",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = { "lua", "php", "javascript", "html", "css", "yaml", "dockerfile", "bash" },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })
  end,
},

-- Fuzzy Finder
{
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Hilfsbibliothek, von vielen Plugins genutzt
  },
  config = function()
    require("telescope").setup({})

    -- Keymaps
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Find in Files" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Find Buffers" })
  end,
},

-- Dateibaum
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Datei-Icons
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 30,
      },
      filesystem = {
        filtered_items = {
          visible = true,  -- versteckte Dateien anzeigen
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    })

    -- Toggle mit Space+e
    vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Filetree" })
  end,
},

-- Statusleiste
{
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lualine").setup({
      options = {
        theme = "tokyonight",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
},

-- LSP
{
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "intelephense", -- PHP
        "lua_ls",       -- Lua
      },
      automatic_installation = true,
    })

    -- LSP Keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,     { buffer = ev.buf, desc = "Go to Definition" })
        vim.keymap.set("n", "K",  vim.lsp.buf.hover,          { buffer = ev.buf, desc = "Hover Docs" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references,     { buffer = ev.buf, desc = "Find References" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
      end,
    })

    -- Neue API: vim.lsp.config statt lspconfig.X.setup
    vim.lsp.config("intelephense", {})
    vim.lsp.config("lua_ls", {})
    vim.lsp.enable({ "intelephense", "lua_ls" })
  end,
},

-- Autocompletion
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",    -- LSP als Quelle
    "hrsh7th/cmp-buffer",      -- Text im Buffer als Quelle
    "hrsh7th/cmp-path",        -- Dateipfade als Quelle
    "L3MON4D3/LuaSnip",        -- Snippet Engine
    "saadparwaiz1/cmp_luasnip", -- Snippets in cmp
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),   -- manuell triggern
        ["<CR>"]      = cmp.mapping.confirm({ select = true }), -- bestätigen
        ["<Tab>"]     = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"]   = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" }, -- LSP zuerst
        { name = "luasnip" },  -- dann Snippets
        { name = "buffer" },   -- dann Buffer-Text
        { name = "path" },     -- dann Dateipfade
      }),
    })
  end,
},

-- Git
{
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      -- Keymaps
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "]c", gs.next_hunk,        { buffer = bufnr, desc = "Next Hunk" })
        vim.keymap.set("n", "[c", gs.prev_hunk,        { buffer = bufnr, desc = "Prev Hunk" })
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk,   { buffer = bufnr, desc = "Stage Hunk" })
        vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo Stage" })
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview Hunk" })
      end,
    })
  end,
},

-- Fugitive
{
  "tpope/vim-fugitive",
  cmd = "Git",
},

-- Buffer übersicht
{
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({})
  end,
},
})
