-- ~/.config/nvim/lua/plugins/lsp.lua

local augroup = vim.api.nvim_create_augroup("LspConfig", { clear = true })

-- ============================================================================
-- Custom :fmt Command
-- ============================================================================
-- Neovim user commands must start with a capital letter (e.g., :Fmt).
-- To allow you to type exactly `:fmt`, we map it using an abbreviation.
vim.api.nvim_create_user_command("Fmt", function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
    print("Formatted buffer")
end, { desc = "Format current buffer with LSP/EFM" })
vim.cmd("cnoreabbrev fmt Fmt")

-- ============================================================================
-- Diagnostics and UI
-- ============================================================================
local diagnostic_signs = { Error = " ", Warn = " ", Hint = "", Info = "" }
vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 4 },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
            [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
            [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
            [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
        },
    },
    underline = true, update_in_insert = false, severity_sort = true,
    float = { border = "rounded", source = "always", header = "", prefix = "", focusable = false, style = "minimal" },
})

do
    local orig = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig(contents, syntax, opts, ...)
    end
end

local function lsp_on_attach(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end
    local bufnr = ev.buf
    local opts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "<leader>gd", function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end, opts)
    vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>gS", function() vim.cmd("vsplit"); vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, opts)
    vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, opts)
    vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set("n", "<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>fd", function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end, opts)
    vim.keymap.set("n", "<leader>fr", function() require("fzf-lua").lsp_references() end, opts)
    vim.keymap.set("n", "<leader>ft", function() require("fzf-lua").lsp_typedefs() end, opts)
    vim.keymap.set("n", "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, opts)
    vim.keymap.set("n", "<leader>fw", function() require("fzf-lua").lsp_workspace_symbols() end, opts)
    vim.keymap.set("n", "<leader>fi", function() require("fzf-lua").lsp_implementations() end, opts)

    if client:supports_method("textDocument/codeAction", bufnr) then
        vim.keymap.set("n", "<leader>oi", function()
            vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" }, diagnostics = {} },
                apply = true, bufnr = bufnr,
            })
            vim.defer_fn(function() vim.lsp.buf.format({ bufnr = bufnr }) end, 50)
        end, opts)
    end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist({ open = true }) end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- ============================================================================
-- Mason Auto-Installation
-- ============================================================================
require("mason").setup()

-- 1. Auto-install LSP Servers
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls", "pyright", "bashls", "ts_ls", "gopls", "clangd", "efm",
    },
    automatic_installation = true,
})

-- 2. Auto-install Linters & Formatters for EFM
require("mason-tool-installer").setup({
    ensure_installed = {
        "stylua", "luacheck", "ruff", "prettierd", "eslint_d", "fixjson",
        "shellcheck", "shfmt", "cpplint", "clang-format", "revive", "gofumpt", "ocamlformat"
    },
    auto_update = false,
    run_on_start = true,
})

-- ============================================================================
-- Blink & LSP Setup
-- ============================================================================
require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<C-Space>"] = { "show", "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = { menu = { auto_show = true } },
    sources = { default = { "lsp", "path", "buffer", "snippets" } },
    snippets = { expand = function(snippet) require("luasnip").lsp_expand(snippet) end },
    fuzzy = { implementation = "prefer_rust", prebuilt_binaries = { download = true } },
})

vim.lsp.config["*"] = { capabilities = require("blink.cmp").get_lsp_capabilities() }

vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } }, telemetry = { enable = false } } } })
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})
vim.lsp.config("ocamllsp", {})

-- ============================================================================
-- EFM Configuration
-- ============================================================================
do
    local luacheck = require("efmls-configs.linters.luacheck")
    local stylua = require("efmls-configs.formatters.stylua")
    local ruff_linter = require("efmls-configs.linters.ruff")     -- <-- Ruff linter
    local ruff_formatter = require("efmls-configs.formatters.ruff") -- <-- Ruff formatter
    local prettier_d = require("efmls-configs.formatters.prettier_d")
    local eslint_d = require("efmls-configs.linters.eslint_d")
    local fixjson = require("efmls-configs.formatters.fixjson")
    local shellcheck = require("efmls-configs.linters.shellcheck")
    local shfmt = require("efmls-configs.formatters.shfmt")
    local cpplint = require("efmls-configs.linters.cpplint")
    local clangfmt = require("efmls-configs.formatters.clang_format")
    local go_revive = require("efmls-configs.linters.go_revive")
    local gofumpt = require("efmls-configs.formatters.gofumpt")

    vim.lsp.config("efm", {
        filetypes = {
            "c", "cpp", "css", "go", "html", "javascript", "javascriptreact",
            "json", "jsonc", "lua", "markdown", "python", "sh", "typescript",
            "typescriptreact", "vue", "svelte",
        },
        init_options = { documentFormatting = true },
        settings = {
            languages = {
                c = { clangfmt, cpplint },
                go = { gofumpt, go_revive },
                cpp = { clangfmt, cpplint },
                css = { prettier_d },
                html = { prettier_d },
                javascript = { eslint_d, prettier_d },
                javascriptreact = { eslint_d, prettier_d },
                json = { eslint_d, fixjson },
                jsonc = { eslint_d, fixjson },
                lua = { luacheck, stylua },
                markdown = { prettier_d },
                python = { ruff_linter, ruff_formatter }, -- <-- Ruff replaces Flake8 & Black
                sh = { shellcheck, shfmt },
                typescript = { eslint_d, prettier_d },
                typescriptreact = { eslint_d, prettier_d },
                vue = { eslint_d, prettier_d },
                svelte = { eslint_d, prettier_d },
            },
        },
    })
end

vim.lsp.enable({
    "lua_ls", "pyright", "bashls", "ts_ls", "gopls", "clangd",
    "ocamllsp",
    "efm",
})
