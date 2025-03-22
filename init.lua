-- =============================--- =============================--- Basic Settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.softtabstop = 4
vim.opt.mouse = "a"
vim.opt.encoding = "UTF-8"
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.g.mapleader = " "
vim.g.codeium_no_map_tab = 1
-- Install Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not ((vim.loop and vim.loop.fs_stat and vim.loop.fs_stat(lazypath)) or vim.fn.isdirectory(lazypath) == 1) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Section
require("lazy").setup({
    -- Existing plugins (shortened for brevity)
    { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "Exafunction/codeium.vim", event = "BufEnter" },
    { "nvim-lualine/lualine.nvim" },
    { "tpope/vim-fugitive" },
    { "lewis6991/gitsigns.nvim" },
    { "ahmedkhalf/project.nvim", config = function() require("project_nvim").setup() end },
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp", dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "L3MON4D3/LuaSnip" } },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "windwp/nvim-autopairs" },
    { "numToStr/Comment.nvim" },
    { "folke/tokyonight.nvim", opts = { style = "storm", on_colors = function(colors) colors.bg = "#000000" end } },
    { "rose-pine/neovim", as = "rose-pine" },
    { "ellisonleao/gruvbox.nvim" },
    { "folke/which-key.nvim" },
    { "ThePrimeagen/harpoon", config = function()
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")
        vim.keymap.set("n", "<Leader>a", mark.add_file, { desc = "Add file to Harpoon" })
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Open Harpoon menu" })
        vim.keymap.set("n", "<Leader>1", function() ui.nav_file(1) end, { desc = "Go to Harpoon file 1" })
        vim.keymap.set("n", "<Leader>2", function() ui.nav_file(2) end, { desc = "Go to Harpoon file 2" })
    end },

    -- New plugins
    { "folke/trouble.nvim" },
    { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" } },
    { "ggandor/leap.nvim" },
    { "folke/zen-mode.nvim" },
    { "echasnovski/mini.nvim" },
})

-- Plugin Configurations
require("nvim-tree").setup({ view = { width = 30, side = "left", adaptive_size = true }, renderer = { icons = { show = { git = true, folder = true, file = true } } }, update_focused_file = { enable = true, update_root = true } })
vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { silent = true })

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", telescope.find_files, { silent = true })
vim.keymap.set("n", "<Leader>f", telescope.live_grep, { silent = true })
vim.keymap.set("n", "<Leader>c", telescope.colorscheme, { desc = "Switch colorscheme" })

require("lualine").setup({ options = { theme = "auto" } })
require("gitsigns").setup()
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "ts_ls", "html", "cssls", "jsonls", "lua_ls" }, automatic_installation = true })
require("lspconfig").ts_ls.setup({ filetypes = { "javascript", "javascriptreact" } })
require("lspconfig").html.setup({})
require("lspconfig").cssls.setup({})
require("lspconfig").jsonls.setup({})
require("lspconfig").lua_ls.setup({ settings = { Lua = { runtime = { version = "LuaJIT" }, diagnostics = { globals = { "vim" } }, workspace = { library = vim.api.nvim_get_runtime_file("", true) }, telemetry = { enable = false } } } })

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        -- Remove Tab mapping from cmp to avoid conflicts
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
    }),
})
require("nvim-autopairs").setup{}
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

require("nvim-treesitter.configs").setup({ ensure_installed = { "lua", "javascript", "typescript", "html", "css", "json" }, highlight = { enable = true }, indent = { enable = true } })

vim.cmd("colorscheme tokyonight-storm")

-- New Plugin Configs
require("trouble").setup({})
vim.keymap.set("n", "<Leader>t", ":TroubleToggle<CR>", { desc = "Toggle Trouble" })

require("neo-tree").setup({ filesystem = { follow_current_file = true } })
vim.keymap.set("n", "<C-b>", ":Neotree toggle<CR>", { silent = true }) -- Overrides nvim-tree

require("leap").add_default_mappings()

require("zen-mode").setup({})
vim.keymap.set("n", "<Leader>z", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })

require("mini.surround").setup()
require("mini.bufremove").setup()
vim.keymap.set("n", "<Leader>bd", ":lua MiniBufremove.delete()<CR>", { desc = "Delete buffer" })

-- General Keybindings
vim.keymap.set("n", "<C-s>", ":w<CR>", { silent = true })
vim.keymap.set("n", "<C-n>", ":enew<CR>", { silent = true })
vim.keymap.set("n", "<C-q>", ":q<CR>", { silent = true })
vim.keymap.set("n", "<C-z>", "u", { silent = true })
vim.keymap.set("n", "<C-S-z>", "<C-r>", { silent = true })
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
vim.keymap.set("v", "<C-x>", '"+d', { silent = true })
vim.keymap.set("i", "<C-v>", '<C-r>+', { silent = true })
vim.keymap.set("n", "<C-v>", '"+p', { silent = true })
vim.keymap.set("n", "<C-Tab>", ":bnext<CR>", { silent = true })
vim.keymap.set("n", "<C-S-Tab>", ":bprevious<CR>", { silent = true })
vim.keymap.set('i', '<Tab>', function()
    if cmp.visible() then
        cmp.confirm({ select = true })
        return ''
    else
        local col = vim.fn.col('.') - 1
        if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
        else
            if vim.fn["codeium#GetStatusString"]() ~= "" then
                return vim.fn["codeium#Accept"]()
            else
                return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
            end
        end
    end
end, { expr = true })
