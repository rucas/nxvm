{
  lib,
  config,
  pkgs,
  ...
}:
{
  extraPackages = with pkgs; [
    black
    isort
    djlint
    jq
    nixfmt
    nodePackages.prettier
    prettierd
    shellcheck
    stylua
    sqruff
    taplo
    typstyle
    yamlfmt
  ];
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters = {
        markdown_gq = {
          format.__raw = ''
            function(self, ctx, lines, callback)
              local textwidth = vim.bo[ctx.buf].textwidth

              -- Early exit if no line exceeds textwidth
              local needs_format = false
              for _, line in ipairs(lines) do
                if #line > textwidth then
                  needs_format = true
                  break
                end
              end

              if not needs_format then
                callback(nil, lines)
                return
              end

              -- Format using vim's built-in formatting
              local bufnr = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

              -- Copy formatting settings from original buffer
              vim.bo[bufnr].textwidth = textwidth
              vim.bo[bufnr].formatoptions = vim.bo[ctx.buf].formatoptions
              vim.bo[bufnr].formatlistpat = vim.bo[ctx.buf].formatlistpat

              vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("silent! normal! gggqG")
              end)

              local formatted = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
              vim.api.nvim_buf_delete(bufnr, { force = true })

              callback(nil, formatted)
            end
          '';
        };
        sqruff = {
          command = "sqruff";
          args = [
            "fix"
            "--force"
            "$FILENAME"
          ];
          stdin = false;
        };
      };
      formatters_by_ft = {
        javascript = [
          "prettierd"
          "prettier"
        ];
        json = [ "jq" ];
        html = [
          "prettierd"
          "prettier"
        ];
        htmlangular = [ "prettierd" ];
        htmldjango = [ "djlint" ];
        lua = [ "stylua" ];
        markdown = [
          "injected"
          "markdown_gq"
        ];
        nix = [ "nixfmt" ];
        python = [
          "isort"
          "black"
        ];
        sh = [ "shellcheck" ];
        sql = [ "sqruff" ];
        toml = [ "taplo" ];
        typescript = [
          "prettierd"
          "prettier"
        ];
        typescriptreact = [
          "prettierd"
          "prettier"
        ];
        typst = [ "typstyle" ];
        yaml = [ "yamlfmt" ];
        "*" = [ "trim_whitespace" ];
      };
    };
  };
  userCommands = lib.mkIf config.plugins.conform-nvim.enable {
    "Format" = {
      command.__raw = ''
        function(args)
          local range = nil
          if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
              start = { args.line1, 0 },
              ["end"] = { args.line2, end_line:len() },
            }
          end
          require("conform").format({ async = true, lsp_fallback = "always", range = range })
        end
      '';
      nargs = "*";
      range = true;
    };
  };
  keymaps = lib.mkIf config.plugins.conform-nvim.enable [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>F";
      action = "<cmd>Format<cr>";
      options = {
        desc = "Format";
      };
    }
  ];
}
