{ helpers, ... }: {
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      onAttach = ''
        vim.api.nvim_create_autocmd("CursorHold", {
          buffer = bufnr,
          callback = function()
            local opts = {
              focusable = false,
              close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
              border = 'rounded',
              source = 'always',
              prefix = ' ',
              scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
          end
        })
      '';
      servers = {
        bashls = { enable = true; };
        cssls = { enable = true; };
        html = { enable = true; };
        jsonls = { enable = true; };
        lua_ls = { enable = true; };
        marksman = { enable = true; };
        nil_ls = { enable = true; };
        nixd = { enable = true; };
        pyright = { enable = true; };
        sqls = { enable = true; };
        terraformls = { enable = true; };
        ts_ls = { enable = true; };
        typos_lsp = { enable = true; };
        yamlls = { enable = true; };
      };
      postConfig = ''
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
          local width = math.floor(vim.o.columns * 0.8)
          local height = math.floor(vim.o.lines * 0.3)
          opts = {
            border = 'rounded',
            max_width = width,
            max_height = height,
          }
          return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end
      '';
      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
  };
  diagnostics = {
    severity_sort = true;
    virtual_text = false;
    virtual_lines = false;
    signs = {
      text = helpers.toRawKeys {
        "vim.diagnostic.severity.ERROR" = "󰅙";
        "vim.diagnostic.severity.WARN" = "";
        "vim.diagnostic.severity.INFO" = "󰋼";
        "vim.diagnostic.severity.HINT" = "󰌵";
      };
    };
  };
  keymaps = [{
    mode = "n";
    key = "<leader>xL";
    action.__raw = ''
      function()
        local new_config = not vim.diagnostic.config().virtual_lines
        vim.diagnostic.config({ virtual_lines = new_config })
      end
    '';
    options = { desc = "Toggle diagnostic virtual_lines"; };
  }];

  #extraConfigLua = ''
  #  local _border = "rounded"

  #  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  #    vim.lsp.handlers.hover, {
  #      border = _border
  #    }
  #  )

  #  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  #    vim.lsp.handlers.signature_help, {
  #      border = _border
  #    }
  #  )

  #  vim.diagnostic.config{
  #    float={border=_border}
  #  };

  #  require('lspconfig.ui.windows').default_options = {
  #    border = _border
  #  }
  #'';
}

