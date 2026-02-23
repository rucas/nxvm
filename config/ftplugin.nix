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
    "ftplugin/markdown.lua".text = ''
      vim.opt_local.textwidth = 120
    '';
    "ftplugin/norg.lua".text = ''
      require("hardtime").disable()
      vim.opt_local.textwidth = 120
      vim.opt_local.foldenable = true
      vim.schedule(function()
        vim.opt_local.foldlevel = 0
      end)

      -- Task item continuation (only for items with checkboxes)
      local function continue_bullet()
        local line = vim.api.nvim_get_current_line()
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))

        -- Try matching asterisk tasks: "*** ( ) TODO" or "**** (x) task"
        local stars, checkbox, star_content = line:match("^(%*+)%s*(%b())%s*(.*)$")

        -- Try matching dash tasks: "  - ( ) item" or "  - (x) item"
        local indent, dash_content
        if not stars then
          indent, checkbox, dash_content = line:match("^(%s*)%-%s*(%b())%s*(.*)$")
        end

        -- Not a task item (no checkbox found), use default Enter behavior
        if not checkbox then
          return vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<CR>", true, false, true),
            "n",
            true
          )
        end

        -- Determine which pattern matched
        local is_asterisk = stars ~= nil
        local task_content = is_asterisk and star_content or dash_content

        -- Empty task item: remove it
        if task_content == "" or task_content == nil then
          vim.api.nvim_set_current_line("")
          return
        end

        -- Create new task item at same level with unchecked checkbox
        local new_bullet
        if is_asterisk then
          new_bullet = stars .. " ( ) "
        else
          new_bullet = indent .. "- ( ) "
        end

        -- Insert new line below current line with the task item
        vim.api.nvim_buf_set_lines(0, row, row, false, {new_bullet})

        -- Move cursor to the new line at the end of the bullet prefix
        vim.api.nvim_win_set_cursor(0, {row + 1, #new_bullet})
      end

      -- Buffer-local keymap
      vim.keymap.set("i", "<CR>", continue_bullet, {
        buffer = 0,
        silent = true,
        desc = "Continue neorg bullet/heading"
      })
    '';
  };
}
