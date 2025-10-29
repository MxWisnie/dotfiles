return {
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local alpha = require 'alpha'
        local theta = require 'alpha.themes.theta'
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = "#70f8ff" })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = "#2ddde6" })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = "#22adb4" })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = "#2d9095" })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = "#2b6f73" })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = "#37787b" })
        vim.api.nvim_set_hl(0, "NeovimDashboardUsername", { fg = "#436d70" })
        theta.nvim_web_devicons.enabled = false
        theta.header.type = "group"
        theta.header.val = {
            {
                type = "text",
                val = "   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
                opts = { hl = "NeovimDashboardLogo1", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
                opts = { hl = "NeovimDashboardLogo2", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
                opts = { hl = "NeovimDashboardLogo3", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
                opts = { hl = "NeovimDashboardLogo4", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
                opts = { hl = "NeovimDashboardLogo5", shrink_margin = false, position = "center" },
            },
            {
                type = "text",
                val = "   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
                opts = { hl = "NeovimDashboardLogo6", shrink_margin = false, position = "center" },
            },
            {
                type = "padding",
                val = 1,
            },
        }
        theta.buttons.val = {
                require "alpha.themes.dashboard".button(".", "Open Current Dir", ":e . <CR>"),
            },

            alpha.setup(theta.config)
    end
}
