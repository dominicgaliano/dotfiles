return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "gopls",
                "eslint",
                "svelte",
                "html",
                "clangd",
                "pyright",
                "csharp_ls",
                "graphql",
                "kotlin_language_server",
            },
        })

        require("mason-lspconfig").setup_handlers({

            -- default handler
            function(server_name)
                vim.lsp.config(server_name, {
                    capabilities = capabilities,
                })
                vim.lsp.enable(server_name)
            end,

            ["lua_ls"] = function()
                vim.lsp.config("lua_ls", {
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            runtime = { version = "Lua 5.1" },
                            diagnostics = {
                                globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                            },
                        },
                    },
                })
                vim.lsp.enable("lua_ls")
            end,

            ["clangd"] = function()
                vim.lsp.config("clangd", {
                    capabilities = capabilities,
                    cmd = { "clangd", "--background-index" },
                    root_dir = vim.fs.root(0, {
                        "compile_commands.json",
                        "compile_flags.txt",
                        ".git",
                    }),
                    settings = {
                        clangd = {
                            completion = {
                                enableSnippets = true,
                            },
                        },
                    },
                })
                vim.lsp.enable("clangd")
            end,

            ["pyright"] = function()
                vim.lsp.config("pyright", {
                    capabilities = capabilities,
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "strict",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                })
                vim.lsp.enable("pyright")
            end,

            ["csharp_ls"] = function()
                vim.lsp.config("csharp_ls", {
                    cmd = { "csharp-ls" },
                    settings = {
                        telemetry = { enabled = false },
                    },
                    root_dir = function(fname)
                        return vim.fs.root(fname, { "*.sln", "*.csproj" })
                    end,
                    filetypes = { "cs" },
                    init_options = {
                        AutomaticWorkspaceInit = true,
                    },
                })
                vim.lsp.enable("csharp_ls")
            end,

            ["kotlin_language_server"] = function()
                vim.lsp.config("kotlin_language_server", {
                    capabilities = capabilities,
                })
                vim.lsp.enable("kotlin_language_server")
            end,
        })


        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                -- it turns out that <Ctrl + Enter> = <new line char>
                -- haven't been able to get this to work, so I am going with C-J for now
                ['<C-J>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
