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

        -- Check if cursor is at end of line (or only whitespace remains)
        local text_after_cursor = line:sub(col + 1)
        local has_text_after = text_after_cursor:match("%S") ~= nil

        -- If there's non-whitespace text after cursor, use normal Enter behavior
        if has_text_after then
          return vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<CR>", true, false, true),
            "n",
            true
          )
        end

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

      -- Normal mode 'o' and 'O' for task continuation
      local function normal_o_below()
        local line = vim.api.nvim_get_current_line()
        local row = vim.api.nvim_win_get_cursor(0)[1]

        -- Try matching asterisk tasks
        local stars, checkbox, star_content = line:match("^(%*+)%s*(%b())%s*(.*)$")

        -- Try matching dash tasks
        local indent, dash_content
        if not stars then
          indent, checkbox, dash_content = line:match("^(%s*)%-%s*(%b())%s*(.*)$")
        end

        -- Not a task item, use default 'o' behavior
        if not checkbox then
          return vim.api.nvim_feedkeys("o", "n", false)
        end

        -- Create new task item
        local is_asterisk = stars ~= nil
        local new_bullet
        if is_asterisk then
          new_bullet = stars .. " ( ) "
        else
          new_bullet = indent .. "- ( ) "
        end

        -- Insert new line and enter insert mode
        vim.api.nvim_buf_set_lines(0, row, row, false, {new_bullet})
        vim.api.nvim_win_set_cursor(0, {row + 1, #new_bullet})
        vim.cmd("startinsert!")
      end

      local function normal_o_above()
        local line = vim.api.nvim_get_current_line()
        local row = vim.api.nvim_win_get_cursor(0)[1]

        -- Try matching asterisk tasks
        local stars, checkbox, star_content = line:match("^(%*+)%s*(%b())%s*(.*)$")

        -- Try matching dash tasks
        local indent, dash_content
        if not stars then
          indent, checkbox, dash_content = line:match("^(%s*)%-%s*(%b())%s*(.*)$")
        end

        -- Not a task item, use default 'O' behavior
        if not checkbox then
          return vim.api.nvim_feedkeys("O", "n", false)
        end

        -- Create new task item
        local is_asterisk = stars ~= nil
        local new_bullet
        if is_asterisk then
          new_bullet = stars .. " ( ) "
        else
          new_bullet = indent .. "- ( ) "
        end

        -- Insert new line above and enter insert mode
        vim.api.nvim_buf_set_lines(0, row - 1, row - 1, false, {new_bullet})
        vim.api.nvim_win_set_cursor(0, {row, #new_bullet})
        vim.cmd("startinsert!")
      end

      -- Buffer-local keymaps
      vim.keymap.set("i", "<CR>", continue_bullet, {
        buffer = 0,
        silent = true,
        desc = "Continue neorg task on Enter"
      })
      vim.keymap.set("n", "o", normal_o_below, {
        buffer = 0,
        silent = true,
        desc = "Create neorg task below"
      })
      vim.keymap.set("n", "O", normal_o_above, {
        buffer = 0,
        silent = true,
        desc = "Create neorg task above"
      })
    '';
  };
}
