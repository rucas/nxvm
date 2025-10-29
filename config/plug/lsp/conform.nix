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

              -- Detect code blocks and skip formatting them
              local in_code_block = false
              local segments = {}
              local current_segment = { is_code = false, lines = {} }

              for i, line in ipairs(lines) do
                -- Check for code fence (``` or ~~~ with optional leading whitespace)
                local is_fence = line:match("^%s*```") or line:match("^%s*~~~")

                if is_fence then
                  -- Save current segment if it has content
                  if #current_segment.lines > 0 then
                    table.insert(segments, current_segment)
                  end

                  -- Toggle code block state
                  in_code_block = not in_code_block

                  -- Start new segment
                  current_segment = { is_code = in_code_block, lines = { line } }
                elseif in_code_block then
                  -- Inside code block - preserve as-is
                  table.insert(current_segment.lines, line)
                else
                  -- Outside code block - add to current segment
                  table.insert(current_segment.lines, line)
                end
              end

              -- Add final segment
              if #current_segment.lines > 0 then
                table.insert(segments, current_segment)
              end

              -- Format each non-code segment
              local result = {}
              for _, segment in ipairs(segments) do
                if segment.is_code then
                  -- Preserve code blocks as-is
                  for _, line in ipairs(segment.lines) do
                    table.insert(result, line)
                  end
                else
                  -- Format non-code segments with gq
                  local bufnr = vim.api.nvim_create_buf(false, true)
                  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, segment.lines)

                  -- Copy formatting settings from original buffer
                  vim.bo[bufnr].textwidth = textwidth
                  vim.bo[bufnr].formatoptions = vim.bo[ctx.buf].formatoptions
                  vim.bo[bufnr].formatlistpat = vim.bo[ctx.buf].formatlistpat

                  vim.api.nvim_buf_call(bufnr, function()
                    vim.cmd("silent! normal! gggqG")
                  end)

                  local formatted = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                  vim.api.nvim_buf_delete(bufnr, { force = true })

                  for _, line in ipairs(formatted) do
                    table.insert(result, line)
                  end
                end
              end

              callback(nil, result)
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
