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
                "spectral",
                "csharp_ls",
                "graphql",
                "kotlin_language_server",
            },

            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["graphql"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.graphql.setup {}
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        capabilities = capabilities,
                        cmd = { "clangd", "--background-index" },
                        root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
                        settings = {
                            clangd = {
                                completion = {
                                    enableSnippets = true
                                }
                            }
                        }
                    }
                end,

                ["pyright"] = function()
                    require("lspconfig").pyright.setup {
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    typecheckingmode = "strict",
                                    autosearchpaths = true,
                                    uselibrarycodefortypes = true,
                                },
                            },
                        },
                    }
                end,

                ["csharp_ls"] = function()
                    require("lspconfig").csharp_ls.setup {
                        cmd = { "csharp-ls" },
                        settings = {
                            telemetry = {
                                enabled = false,
                            },
                        },
                        root_dir = function(fname)
                            local util = require("lspconfig.util")
                            return util.root_pattern '*.sln' (fname) or util.root_pattern '*.csproj' (fname)
                        end,
                        filetypes = { 'cs' },
                        init_options = {
                            AutomaticWorkspaceInit = true,
                        },
                    }
                end,


                ["jdtls"] = function()
                    require("lspconfig").jdtls.setup {
                        settings = {
                            ['jdtls'] = {},
                        }
                    }
                end,

                ["spectral"] = function()
                    require("lspconfig").spectral.setup {
                    }
                end,

                ["kotlin_language_server"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.kotlin_language_server.setup {
                        capabilities = capabilities,
                        -- root_dir = lspconfig.util.root_pattern("settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git"),
                    }
                end,

                -- hands down the most annoying thing ever
                -- need to figure out how to toggle it and have it default off
                -- before I re-enabled
                -- keep this here because I do find it useful for class reports
                -- ["harper-ls"] = function()
                --     require("lspconfig").harper_ls.setup {
                --         settings = {
                --             ["harper-ls"] = {
                --                 linters = {
                --                     spell_check = true,
                --                     spelled_numbers = false,
                --                     an_a = true,
                --                     sentence_capitalization = true,
                --                     unclosed_quotes = true,
                --                     wrong_quotes = false,
                --                     long_sentences = true,
                --                     repeated_words = true,
                --                     spaces = true,
                --                     matcher = true,
                --                     correct_number_suffix = true,
                --                     number_suffix_capitalization = true,
                --                     multiple_sequential_pronouns = true,
                --                     linking_verbs = false,
                --                     avoid_curses = true,
                --                     terminating_conjunctions = true
                --                 }
                --             }
                --         },
                --     }
                -- end,
            }
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
