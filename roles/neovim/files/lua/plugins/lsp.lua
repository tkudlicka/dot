local diagnostic_ns = vim.api.nvim_create_namespace('lsp_diagnostics')
local lsp_group = vim.api.nvim_create_augroup('vimrc_lsp', { clear = true })

local diagnostic_icons = {
  [vim.diagnostic.severity.ERROR] = ' ',
  [vim.diagnostic.severity.WARN] = ' ',
  [vim.diagnostic.severity.INFO] = ' ',
  [vim.diagnostic.severity.HINT] = ' ',
}


local setup = {}

function setup.configure_handlers()
  vim.diagnostic.config({
    virtual_text = false,
    signs = {
      text = diagnostic_icons,
    },
  })

  vim.lsp.handlers['textDocument/hover'] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', focusable = false })

  vim.lsp.handlers['textDocument/signatureHelp'] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single', focusable = false, silent = true })
end

local function show_diagnostics()
  vim.schedule(function()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

    local virtual_text_opts = {
      prefix = function(diagnostic)
        return diagnostic_icons[diagnostic.severity]
      end or '',
    }

    if vim.fn.has('nvim-0.10.0') == 0 then
      virtual_text_opts = {
        prefix = '',
        format = function(diagnostic)
          return string.format('%s %s', diagnostic_icons[diagnostic.severity], diagnostic.message)
        end,
      }
    end

    vim.diagnostic.show(diagnostic_ns, bufnr, diagnostics, {
      virtual_text = virtual_text_opts,
      severity_sort = true,
    })
  end)
end

local function refresh_diagnostics()
  vim.diagnostic.setloclist({ open = false })
  show_diagnostics()
  if vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.cmd.lclose()
  end
end

function setup.attach_to_buffer(client, bufnr)
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    buffer = bufnr,
    callback = show_diagnostics,
    group = lsp_group,
  })
  vim.api.nvim_create_autocmd('DiagnosticChanged', {
    buffer = bufnr,
    callback = refresh_diagnostics,
    group = lsp_group,
  })
  if not vim.tbl_isempty(client.server_capabilities.signatureHelpProvider or {}) then
    vim.api.nvim_create_autocmd('CursorHoldI', {
      buffer = bufnr,
      callback = function()
        vim.defer_fn(function()
          vim.lsp.buf.signature_help()
        end, 500)
      end,
      group = lsp_group,
    })
  end
  vim.opt.foldmethod = 'expr'
  vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
  setup.mappings()
end


  local function lsp_setup(opts)
    opts = opts or {}
    return vim.tbl_deep_extend('force', {
      on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
        if client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, bufnr)
        end
        setup.attach_to_buffer(client, bufnr)
        if opts.disableFormatting then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end,
    }, opts or {})
  end
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        'yioneko/nvim-vtsls' ,
        'folke/neodev.nvim' ,
        'stevearc/conform.nvim' ,
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "onsails/lspkind-nvim",
        'nanotee/sqls.nvim',
    },

    config = function()
        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities())
        local ok, lspkind = pcall(require, "lspkind")
        if not ok then
            return
        end

        lspkind.init {
            symbol_map = {
                Copilot = "",
            },
        }

        require("fidget").setup({})
        require("mason").setup({})
        require("mason-lspconfig").setup({
            ensure_insalled = {
                "lua_ls",
                "rust_analyzer",
                "templ",
                "vtsls",
                "html",
                "htmx",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ['vtsls'] = function()
                    local vtsls_settings = {
                        preferences = {
                            quoteStyle = 'single',
                            importModuleSpecifier = 'relative',
                        },
                        inlayHints = {
                            parameterNames = { enabled = 'literals' },
                            parameterTypes = { enabled = true },
                            variableTypes = { enabled = true },
                            propertyDeclarationTypes = { enabled = true },
                            functionLikeReturnTypes = { enabled = true },
                            enumMemberValues = { enabled = true },
                        },
                        tsserver = {
                            experimental = {
                                    enableProjectDiagnostics = true,
                                },

                        },
                    }
                    local lspconfig = require("lspconfig")
                    lspconfig.vtsls.setup(lsp_setup({
                        settings = {
                            javascript = vtsls_settings,
                            typescript = vtsls_settings,
                            vtsls = {
                                experimental = {
                                    enableProjectDiagnostics = true,
                                    completion = {
                                        enableServerSideFuzzyMatch = true,
                                    },
                                },
                            },
                        },
                        disableFormatting = true,
                    }))
                end,
                ['sqls'] = function() 
                    require('lspconfig').sqls.setup{
                        cmd={"/Users/tomaskudlicka/go/bin/sqls", "-config","~/.config/sqls/config.yml"},
                        on_attach = function(client, bufnr)
                            print("Attaching to sqls")
                            require('sqls').on_attach(client, bufnr)
                        end
                    }
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim"}
                                }
                            }
                        }
                    }
                end,
                ["htmx"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.htmx.setup {
                        filetypes = { "templ","html" },
                        capabilities = capabilities,
                    }
                    lspconfig.html.setup {
                        filetypes = { "templ","html" },
                        capabilities = capabilities,
                    }
                end,
            }
        })

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                -- Enable completion triggered by <c-x><c-o>
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                -- Buffer local mappings.
                -- See `:help vim.lsp.*` for documentation on any of the below functions
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'gk', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wd', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<space>f', function()
                    vim.lsp.buf.format { async = true }
                end, opts)

            end,
        })
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sorting = {
                    -- TODO: Would be cool to add stuff like "See variable names before method names" in rust, or something like that.
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,

                        -- copied from cmp-under, but I don't think I need the plugin for this.
                        -- I might add some more of my own.
                        function(entry1, entry2)
                            local _, entry1_under = entry1.completion_item.label:find "^_+"
                            local _, entry2_under = entry2.completion_item.label:find "^_+"
                            entry1_under = entry1_under or 0
                            entry2_under = entry2_under or 0
                            if entry1_under > entry2_under then
                                return false
                            elseif entry1_under < entry2_under then
                                return true
                            end
                        end,

                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },

               mapping = cmp.mapping.preset.insert({
                    ['C-p'] = cmp.mapping.select_prev_item(cmp_select),
                    ['C-n'] = cmp.mapping.select_next_item(cmp_select),
                    ['C-y'] = cmp.mapping.confirm({ select = true }),
                    ['C-space'] = cmp.mapping.complete(),
                    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<c-y>"] = cmp.mapping(
                    cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    },
                    { "i", "c" }
                    ),
                    ["<M-y>"] = cmp.mapping(
                    cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    { "i", "c" }
                    ),

                    ["<c-space>"] = cmp.mapping {
                        i = cmp.mapping.complete(),
                        c = function(
                            _ --[[fallback]]
                            )
                            if cmp.visible() then
                                if not cmp.confirm { select = true } then
                                    return
                                end
                            else
                                cmp.complete()
                            end
                        end,
                    },

                    -- ["<tab>"] = false,
                    ["<tab>"] = cmp.config.disable,

                    -- Cody completion
                    ["<c-a>"] = cmp.mapping.complete {
                        config = {
                            sources = {
                                { name = "cody" },
                            },
                        },
                    },

                    -- Testing
                    ["<c-q>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                }),
                sources = cmp.config.sources({
                    { name = "cody" },
                    { name = "nvim_lua" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "copilot" },
                    { name = "eruby" },
                }, {
                    { name = "path" },
                    { name = "buffer", keyword_length = 5 },
                }, {
                    { name = "gh_issues" },
                }),
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        luasnip = "[snip]",
        gh_issues = "[issues]",
        tn = "[TabNine]",
        eruby = "[erb]",
        cody = "[cody]",
      },
    },
  },

  experimental = {
    -- I like the new menu better! Nice work hrsh7th
    native_menu = false,

    -- Let's play with this for a day or two
    ghost_text = false,
  },
            })

                vim.diagnostic.config({
                    virtual_text = true
                })
            end
        }
