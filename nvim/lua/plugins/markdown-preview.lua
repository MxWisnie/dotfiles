return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    ft = { "markdown" },
    opts = {
        render_modes = { "n", "c", "t", "i" },
        heading = {
            sign = false,
            icons = { "" },
            width = "block",
            min_width = 80,
            border = true,
            border_virtual = true,
            position = "inline",
            left_pad = { 0, 3, 6, 9, 12, 15 },
            backgrounds = { "RenderMarkdownH1Bg", "RenderMarkdownH2Bg" },
        },
        bullet = {
            highlight = "Normal",
        },
        checkbox = {
            custom = {
                todo = {
                    raw = "[?]",
                    rendered = "󰥔 ",
                    highlight = "RenderMarkdownTodo",
                    scope_highlight = nil,
                },
            },
        },
        latex = { enabled = false },
        code = {
            --  none:     disables all rendering
            --  normal:   adds highlight group to code blocks & inline code, adds padding to code blocks
            --  language: adds language icon to sign column if enabled and icon + name above code blocks
            --  full:     normal + language
            style = "normal",
            position = "left",
            language_pad = 0,
            language_name = false,
            above = "▄",
            below = "▀",
            highlight = "RenderMarkdownCode",
        },
        completions = { lsp = { enabled = true } },
    },
    init = function()
        local fg_color = "fg"
        local bg_color = "#121212"
        local bg_color1 = vim.api.nvim_get_hl(0, { name = "GruvboxBg0" }).fg
        vim.api.nvim_set_hl(
            0,
            "RenderMarkdownCode",
            vim.tbl_extend(
                "force",
                vim.api.nvim_get_hl(0, { name = "RenderMarkdownCode" }),
                { bg = bg_color1 }
            )
        )
        vim.api.nvim_set_hl(
            0,
            "RenderMarkdownH1Bg",
            { fg = fg_color, bg = bg_color, bold = true }
        )
        vim.api.nvim_set_hl(
            0,
            "RenderMarkdownH2Bg",
            { fg = fg_color, bg = bg_color, bold = false, italic = true }
        )
    end,
}
