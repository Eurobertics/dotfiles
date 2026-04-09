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
vim.opt.mouse = ""          -- Maus komplett deaktivieren
-- vim.opt.undofile = true     -- Undo-Historie persistent speichern

-- Pfeiltasten deaktivieren (Homerow erzwingen)
vim.keymap.set("n", "<Up>",    "<Nop>")
vim.keymap.set("n", "<Down>",  "<Nop>")
vim.keymap.set("n", "<Left>",  "<Nop>")
vim.keymap.set("n", "<Right>", "<Nop>")

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

-- Colorscheme Tokyo Night
{
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "moon",
    })
--    vim.cmd("colorscheme tokyonight-moon")
  end,
},

-- OneDark Colorscheme
{
  "olimorris/onedarkpro.nvim",
  priority = 1000,
  config = function()
    require("onedarkpro").setup({})
    vim.cmd("colorscheme onelight")
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
--  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        file_ignore_patterns = {
          "node_modules/", -- node_modules ignorieren
          "vendor/",       -- PHP vendor ignorieren
        },
      },
    --   pickers = {
    --     find_files = {
    --       hidden = true,
    --     },
    --     live_grep = {
    --       additional_args = { "--hidden" },
    --     },
    --   },
    -- })

    -- Keymaps: Space + f = Find
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Find in Files (Grep)" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Find Buffers" })
  end,
},

-- Dateibaum
{
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 30,
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    })

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

    -- Keymaps: Space + l = LSP
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        vim.keymap.set("n", "gd",         vim.lsp.buf.definition,  { buffer = ev.buf, desc = "Go to Definition" })
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,        { buffer = ev.buf, desc = "Hover Docs" })
        vim.keymap.set("n", "gr",         vim.lsp.buf.references,   { buffer = ev.buf, desc = "Find References" })
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,       { buffer = ev.buf, desc = "LSP Rename" })
        vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition,   { buffer = ev.buf, desc = "LSP Definition" })
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.references,   { buffer = ev.buf, desc = "LSP References" })
      end,
    })

    vim.lsp.config("intelephense", {})
    vim.lsp.config("lua_ls", {})
    vim.lsp.enable({ "intelephense", "lua_ls" })
  end,
},

-- Autocompletion
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
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
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"]      = cmp.mapping.confirm({ select = true }),
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
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
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
      -- Keymaps: Space + g = Git
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "]c",         gs.next_hunk,         { buffer = bufnr, desc = "Next Hunk" })
        vim.keymap.set("n", "[c",         gs.prev_hunk,         { buffer = bufnr, desc = "Prev Hunk" })
        vim.keymap.set("n", "<leader>gn", gs.next_hunk,         { buffer = bufnr, desc = "Git Next Hunk" })
        vim.keymap.set("n", "<leader>gp", gs.prev_hunk,         { buffer = bufnr, desc = "Git Prev Hunk" })
        vim.keymap.set("n", "<leader>gs", gs.stage_hunk,        { buffer = bufnr, desc = "Git Stage Hunk" })
        vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk,   { buffer = bufnr, desc = "Git Undo Stage" })
        vim.keymap.set("n", "<leader>gh", gs.preview_hunk,      { buffer = bufnr, desc = "Git Preview Hunk" })
      end,
    })
  end,
},

-- Fugitive
{
  "tpope/vim-fugitive",
  cmd = "Git",
},

-- Buffer Übersicht
{
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup({})
  end,
},

-- DAP Core
{
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    require("mason-nvim-dap").setup({
      ensure_installed = { "php" },
      automatic_installation = true,
    })

    local dap = require("dap")
    local dapui = require("dapui")

    dap.adapters.php = {
      type = "executable",
      command = "node",
      args = {
        vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
      },
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Xdebug CLI",
        port = 9003,
        pathMappings = {
          ["${workspaceFolder}"] = "${workspaceFolder}",
        },
      },
      {
        type = "php",
        request = "launch",
        name = "Xdebug Web",
        port = 9003,
        pathMappings = {
          ["/var/www/html"] = "${workspaceFolder}",
        },
      },
    }

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    -- Keymaps: Space + d = DAP, F-Tasten als Alternative
    vim.keymap.set("n", "<F5>",        dap.continue,          { desc = "DAP Continue" })
    vim.keymap.set("n", "<F10>",       dap.step_over,         { desc = "DAP Step Over" })
    vim.keymap.set("n", "<F11>",       dap.step_into,         { desc = "DAP Step Into" })
    vim.keymap.set("n", "<F12>",       dap.step_out,          { desc = "DAP Step Out" })
    vim.keymap.set("n", "<leader>db",  dap.toggle_breakpoint, { desc = "DAP Breakpoint" })
    vim.keymap.set("n", "<leader>dc",  dap.continue,          { desc = "DAP Continue" })
    vim.keymap.set("n", "<leader>dx",  function()
      require("dap").terminate()
      require("dapui").close()
    end, { desc = "DAP Beenden" })

    require("dapui").setup()
  end,
},

-- Auskommentieren leicht gemacht
{
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup({})
  end,
},
})
