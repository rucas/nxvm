{ config, ... }:
let
  colors = import ../colors/${config.theme}.nix;
in
{
  extraFiles = {
    "ftplugin/toggleterm.lua".text = ''
      vim.opt_local.spell = false
    '';
    "ftplugin/checkhealth.lua".text = ''
      vim.opt_local.spell = false
    '';
    "ftplugin/norg.lua".text = ''
      -- Calendar highlighting for norg files only
      -- Colors imported from nix config
      local colors = {
        base03 = "${colors.base03}",
        base05 = "${colors.base05}",
        base09 = "${colors.base09}", -- bright orange
        base0B = "${colors.base0B}", -- bright green
        base0D = "${colors.base0D}", -- blue
      }

      -- Define calendar-specific highlight groups
      vim.api.nvim_set_hl(0, "NeorgCalendarMonth", {
        fg = colors.base09, -- bright orange
        bold = true
      })

      vim.api.nvim_set_hl(0, "NeorgCalendarHeader", {
        fg = colors.base0D, -- blue
        bold = true
      })

      vim.api.nvim_set_hl(0, "NeorgCalendarDay", {
        fg = colors.base0B -- bright green
      })

      vim.api.nvim_set_hl(0, "NeorgCalendarWeek", {
        fg = colors.base03 -- dimmed
      })

      -- Function to highlight calendar
      local function highlight_calendar()
        local buf = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

        for line_num, line in ipairs(lines) do
          -- Match month/year headers like "August 2025"
          if line:match("^%s*%a+%s+%d%d%d%d%s*$") then
            vim.api.nvim_buf_add_highlight(buf, -1, "NeorgCalendarMonth", line_num - 1, 0, -1)

          -- Match calendar headers like "Mo Tu We Th Fr Sa Su CW"
          elseif line:match("^%s*Mo%s+Tu%s+We%s+Th%s+Fr%s+Sa%s+Su%s+CW%s*$") then
            vim.api.nvim_buf_add_highlight(buf, -1, "NeorgCalendarHeader", line_num - 1, 0, -1)

          -- Match calendar rows with numbers
          elseif line:match("^%s*%d") and line:match("%d%d%s*$") then
            -- Week number is at the end (last digits before end of line)
            local week_num = line:match("(%d%d)%s*$")
            if week_num then
              local week_start = line:find(week_num .. "%s*$")
              vim.api.nvim_buf_add_highlight(buf, -1, "NeorgCalendarWeek",
              line_num - 1, week_start - 1, week_start + #week_num - 1)
            end

            -- Day numbers are all other numbers in the line (not at the end)
            local line_without_week = line:gsub("%d%d%s*$", "")
            for start_pos, day_num, end_pos in line_without_week:gmatch("()(%d%d?)()") do
              vim.api.nvim_buf_add_highlight(buf, -1, "NeorgCalendarDay", line_num - 1, start_pos - 1, end_pos - 1)
            end
          end
        end
      end

      -- Apply highlighting immediately and on autocmds
      vim.defer_fn(highlight_calendar, 100)

      -- Re-highlight on various events
      vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "TextChanged", "TextChangedI"}, {
        buffer = 0,
        callback = function()
          vim.defer_fn(highlight_calendar, 10)
        end
      })

    '';
  };
}
