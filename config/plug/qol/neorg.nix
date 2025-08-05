{ self', ... }:
{
  extraPlugins = [
    self'.packages.neorg-interim-ls
  ];

  extraConfigLua = ''
    -- Custom function to add strikethrough to completed tasks and highlight markers
    local function apply_task_strikethrough()
      local bufnr = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

      -- Clear previous highlights
      vim.api.nvim_buf_clear_namespace(bufnr, -1, 0, -1)

      for i, line in ipairs(lines) do
        -- Pattern to match tasks at any level
        local task_start, task_end = line:find("^(%s*[%*%-]+ %(x%) )")

        if task_start then
          -- Highlight the marker/icon part (without strikethrough)
          local marker_start = line:find("[%*%-]")  -- Find first * or -
          local marker_end = task_end - 1  -- End just before the task text

          if marker_start then
            vim.api.nvim_buf_add_highlight(
              bufnr,
              -1,
              "NeorgTaskDoneMarker",
              i-1,              -- line number (0-indexed)
              marker_start-1,   -- start column (0-indexed)
              marker_end        -- end column
            )
          end

          -- Highlight the task text (with strikethrough)
          local text_start = task_end + 1
          local text_end = #line

          if text_start <= text_end then
            vim.api.nvim_buf_add_highlight(
              bufnr,
              -1,
              "NeorgTaskDoneText",
              i-1,           -- line number (0-indexed)
              text_start-1,  -- start column (0-indexed)
              text_end       -- end column
            )
          end
        end
      end
    end

    -- Create the highlight groups
    vim.api.nvim_set_hl(0, "NeorgTaskDoneMarker", {
      fg = "#6c7086"  -- Muted color for marker, no strikethrough
    })

    vim.api.nvim_set_hl(0, "NeorgTaskDoneText", {
      strikethrough = true,
      fg = "#6c7086"  -- Same muted color with strikethrough for text
    })

    -- Apply on buffer enter and text change
    vim.api.nvim_create_autocmd({"BufEnter", "TextChanged", "TextChangedI"}, {
      pattern = "*.norg",
      callback = apply_task_strikethrough
    })
  '';

  plugins.neorg = {
    enable = true;
    modules = {
      "core.defaults" = {
        __empty = null;
      };
      "core.concealer" = {
        config = {
          icon_preset = "basic";
          icons = {
            heading = {
              icons = [
                "◉"
                "◎"
                "○"
                "⊛"
                "¤"
                "∘"
              ];
            };
            todo = {
              pending = {
                icon = " ";
              };
              uncertain = {
                icon = "?";
              };
              urgent = {
                icon = "!";
              };
              on_hold = {
                icon = "-";
              };
              cancelled = {
                icon = "_";
              };
              done = {
                icon = "x";
              };
              recurring = {
                icon = "+";
              };
            };
          };
        };
      };
      "core.completion" = {
        config = {
          engine = {
            module_name = "external.lsp-completion";
          };
        };
      };
      "core.esupports.hop" = {
        config = {
          external_file_mode = "split";
        };
      };
      "external.interim-ls" = {
        config = {
          completion_provider = {
            enable = true;
            documentation = true;
          };
        };
      };
    };
  };
}
