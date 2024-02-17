local lspconfig = require "lspconfig"
local tailwindcssls_default_config = require("lspconfig.server_configurations.tailwindcss").default_config

local tailwindcssls_default_filetypes = tailwindcssls_default_config.filetypes
local tailwindcss_default_userLanguages = tailwindcssls_default_config.init_options.userLanguages

table.insert(tailwindcssls_default_filetypes, "templ")
tailwindcss_default_userLanguages.templ = "templ"

lspconfig.tailwindcss.setup {}
