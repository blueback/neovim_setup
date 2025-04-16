-- NOTE: to make any of this work you need a language server.
-- If you don't know what that is, watch this 5 min video:
-- https://www.youtube.com/watch?v=LaS32vctfOY

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

------------------------------------------------------------------------------------
------------------------------NEW way to select languages---------------------------
------------------------------------------------------------------------------------
require('mason').setup({})
require('mason-lspconfig').setup({
  --- This can be used to ensure these lsp servers are installed
  ---ensure_installed = { "verible" },
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})
------------------------------------------------------------------------------------
-------------------------------- Formatting Options --------------------------------
------------------------------------------------------------------------------------
--- This can be used to pass formatting options to lsp servers
local do_lsp_formatting_config = false
if (do_lsp_formatting_config) then
  require('mason-lspconfig').setup_handlers({
    ["verible"] = function()
      print("setting verible")
      require("lspconfig").verible.setup({
        settings = {
          verilog = {
            formatOptions = {
              indentWidth = 4
            }
          }
        }
      })
    end
  })
end

------------------------------------------------------------------------------------
------------------------OLD way to manually select languages------------------------
------------------------------------------------------------------------------------
--- -- You'll find a list of language servers here:
--- -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
--- -- These are example language servers. 
--- require('lspconfig').gleam.setup({})
--- require('lspconfig').ocamllsp.setup({})
--- require('lspconfig').clangd.setup({})


------------------------------------------------------------------------------------
----------------------Setup OLD autocomplete----------------------------------------
------------------------------------------------------------------------------------
-- local cmp = require('cmp')
-- 
-- cmp.setup({
--   sources = {
--     {name = 'nvim_lsp'},
--   },
--   mapping = cmp.mapping.preset.insert({}),
--   snippet = {
--     expand = function(args)
--       -- You need Neovim v0.10 to use vim.snippet
--       vim.snippet.expand(args.body)
--     end,
--   },
-- })


------------------------------------------------------------------------------------
----------------------Setup NEW autocomplete----------------------------------------
------------------------------------------------------------------------------------
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

------------------------------------------------------------------------------------
----------------- Setup diagnostic messages to come for lsp errors -----------------
------------------------------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = true,
})
