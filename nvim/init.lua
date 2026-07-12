vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.pack.add({
    { src = "https://github.com/projekt0n/github-nvim-theme" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    { src = "https://github.com/saghen/blink.lib" },
    { src = "https://github.com/saghen/blink.cmp" },

    { src = "https://github.com/windwp/nvim-autopairs" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

vim.cmd('packadd nvim.tohtml')
vim.cmd('packadd nvim.undotree')


-- vim.cmd('colorscheme catppuccin')
vim.cmd('colorscheme github_dark_tritanopia')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 0

-- Buffer & Window Management
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

-- Resize Windows
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Move Lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Diagnostic keymaps
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Show diagnostic error/warning" })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- Utils
vim.keymap.set("n", "<leader>pa", function()
    local path = vim.fn.expand("%:p")
    vim.fn.setreg("+", path)
    print("file:", path)
end, { desc = "Copy full file path" })

-- CP command: copy whole file to system clipboard
vim.api.nvim_create_user_command("CP", function()
    vim.cmd([[ %y+ ]])
    print("File copied to system clipboard ✅")
end, {})

-- vim.api.nvim_create_user_command("RUN", function()
--     local file = vim.fn.expand("%")
--     local output = vim.fn.expand("%:r") -- same name without extension
--     -- vim.cmd("!g++ " .. file .. " -o " .. output .. " && ./" .. output)
--     vim.cmd("!g++ -std=c++17 -O2 -Wall -Wextra -Wshadow -Wconversion -Wunreachable-code -Wreturn-type -Wno-unused-result " .. file .. " -o " .. output)
--     vim.cmd("!g++ " .. file .. " -o " .. output)
-- end, {})

vim.api.nvim_create_user_command("RUN", function()
    vim.cmd("w") -- Always save before compiling
    
    local file = vim.fn.expand("%")
    local output = vim.fn.expand("%:r")
    
    -- Construct the full command string
    -- 1. Compile with your specific CP flags
    -- 2. If successful (&&), run the binary
    local flags = "-std=c++17 -O2 -Wall -Wextra -Wshadow -Wconversion -Wunreachable-code -Wreturn-type -Wno-unused-result"
    local cmd = string.format("g++ %s %s -o %s && ./%s", flags, file, output, output)

    -- Open a terminal in a bottom split and run it
    vim.cmd("botright split | resize 12 | term " .. cmd)
    vim.cmd("startinsert") -- Auto-focus the terminal for input
end, {})

-- Keymap for convenience
vim.keymap.set("n", "<leader>r", ":RUN<CR>", { desc = "Compile and Run C++" })

vim.keymap.set("n", "<leader>cp", ":CP<CR>", { desc = "Copy whole file to clipboard" })
vim.keymap.set("n", "<leader>u", require("undotree").open)
-- end KEYMAPS

-- begin PLUGIN CONFIGURATION

-- 1. Blink CMP Setup
local cmp = require('blink.cmp')

-- This will download and build the necessary Rust binaries
cmp.build():pwait()

cmp.setup({

    keymap = {
        preset = "default",
        -- ["<C-space>"] = {
		-- 	"show",
		-- 	"show_documentation",
		-- 	"hide_documentation",
		-- },
		-- ["<C-y>"] = { "select_and_accept" },
		--
		-- ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
		-- ["<C-n>"] = { "select_next", "fallback_to_mappings" },
		--
		-- ["<C-b>"] = { "scroll_documentation_up", "fallback" },
		-- ["<C-f>"] = { "scroll_documentation_down", "fallback" },
		--
		-- ["<C-l>"] = { "snippet_forward", "fallback" },
		-- ["<C-h>"] = { "snippet_backward", "fallback" },
		--
		-- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },
    signature = { enabled = true },

    appearance = {
        nerd_font_variant = "mono",
    },

    completion = {
        documentation = { auto_show = true },
        keyword = { range = "full" },
        menu = {
            auto_show = function(ctx, item)
                if vim.bo.filetype == "markdown" or vim.bo.filetype == "tex" or vim.bo.filetype == "typst" then
                    return false
                end
                return true
            end,
            border = "padded",
            draw = {
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                    { "source_name" },
                },
            },
        },
        ghost_text = { enabled = false },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
})

-- 2. Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

-- 3. Mason Tool Installer (Auto-installs servers)
require("mason-tool-installer").setup({
    ensure_installed = {
        "clangd",                 -- C++
        "pyright",                -- Python
        "ts_ls",                  -- Javascript / Typescript
        "dockerls",               -- Docker
        "lua_ls",                 -- Lua
        "jdtls",                  -- Java
        "kotlin_language_server", -- Kotlin
    },
    auto_update = false,
    run_on_start = true,
})

-- 4. Mason LSPConfig & Nvim-LSPConfig bridge
local capabilities = require('blink.cmp').get_lsp_capabilities()
local lspconfig = require("lspconfig")

require("mason-lspconfig").setup({
    handlers = {
        function(server_name)
            lspconfig[server_name].setup({
                capabilities = capabilities,
            })
        end,
        
        ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" }
                        }
                    }
                }
            })
        end,
    }
})

-- 5. Auto Pairs Setup
require("nvim-autopairs").setup({
    check_ts = true,
})

-- 6. Treesitter Setup
-- Note: You may need to run `:TSUpdate` after starting Neovim to compile the parsers.
require("nvim-treesitter.config").setup({
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "javascript", "typescript", "java", "markdown" },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})

-- 7. Lualine Setup (with Branch and Python VENV)
local function env_cleanup(venv)
    if string.find(venv, "/") then
        local final_venv = venv
        for w in venv:gmatch("([^/]+)") do
            final_venv = w
        end
        venv = final_venv
    end
    return venv
end

local function python_venv()
    local venv = os.getenv("CONDA_DEFAULT_ENV") or os.getenv("VIRTUAL_ENV")
    if venv then
        return "🐍 " .. env_cleanup(venv)
    end
    return ""
end

require('lualine').setup({
    options = {
        theme = 'auto',
        globalstatus = true,
    },
    sections = {
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { python_venv, 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
})
-- end PLUGIN CONFIGURATION
