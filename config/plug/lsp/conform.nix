{ lib, config, pkgs, ... }: {
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
    yamlfmt
  ];
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters = {
        sqruff = {
          command = "sqruff";
          args = [ "fix" "--force" "$FILENAME" ];
          stdin = false;
        };
      };
      formatters_by_ft = {
        javascript = [ "prettierd" "prettier" ];
        json = [ "jq" ];
        html = [ "prettierd" "prettier" ];
        htmlangular = [ "prettierd" ];
        htmldjango = [ "djlint" ];
        lua = [ "stylua" ];
        markdown = [ "injected" ];
        nix = [ "nixfmt" ];
        python = [ "isort" "black" ];
        sh = [ "shellcheck" ];
        sql = [ "sqruff" ];
        toml = [ "taplo" ];
        typescript = [ "prettierd" "prettier" ];
        typescriptreact = [ "prettierd" "prettier" ];
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
          require("conform").format({ async = true, lsp_format = "fallback", range = range })
        end
      '';
      nargs = "*";
      range = true;
    };
  };
  keymaps = lib.mkIf config.plugins.conform-nvim.enable [{
    mode = [ "n" "v" ];
    key = "<leader>F";
    action = "<cmd>Format<cr>";
    options = { desc = "Format"; };
  }];
}
