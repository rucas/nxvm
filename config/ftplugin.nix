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

      -- Auto-move completed tasks to bottom of list
      local function is_completed_task(line)
        -- Match asterisk format: "*** (x) task"
        local stars, checkbox = line:match("^(%*+)%s*(%b())")
        if stars and checkbox == "(x)" then
          return true, false, #stars
        end

        -- Match dash format: "  - (x) task"
        local indent, dash_checkbox = line:match("^(%s*)%-%s*(%b())")
        if indent and dash_checkbox == "(x)" then
          return true, true, #indent
        end

        return false, false, 0
      end

      local function get_task_end_line(start_line)
        local total_lines = vim.api.nvim_buf_line_count(0)
        local current = start_line

        while current < total_lines do
          local line = vim.api.nvim_buf_get_lines(0, current, current + 1, false)[1]
          -- Check if line ends with backslash continuation
          if not line:match("\\%s*$") then
            return current
          end
          current = current + 1
        end

        return current
      end

      local function find_list_bottom(task_start_line, task_level, is_dash)
        local total_lines = vim.api.nvim_buf_line_count(0)
        local bottom = task_start_line

        for i = task_start_line + 1, total_lines do
          local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

          -- Skip empty lines
          if line:match("^%s*$") then
            goto continue
          end

          -- Skip continuation lines
          if i > task_start_line + 1 then
            local prev_line = vim.api.nvim_buf_get_lines(0, i - 2, i - 1, false)[1]
            if prev_line:match("\\%s*$") then
              goto continue
            end
          end

          if is_dash then
            -- For dash tasks, stop at any heading
            if line:match("^%*+") then
              break
            end
            bottom = i
          else
            -- For asterisk tasks, stop at parent level or same-level heading
            local stars = line:match("^(%*+)")
            if stars then
              if #stars < task_level then
                -- Parent level heading, stop here
                break
              elseif #stars == task_level then
                -- Same level - check if it's a task or heading
                if not line:match("^%*+%s*%b()") then
                  -- Same-level heading without checkbox, stop here
                  break
                end
              end
            end
            bottom = i
          end

          ::continue::
        end

        return bottom
      end

      local function move_task_to_bottom()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_line_num = cursor_pos[1]
        local line = vim.api.nvim_buf_get_lines(0, current_line_num - 1, current_line_num, false)[1]

        -- Check if current line is a completed task
        local is_completed, is_dash, level = is_completed_task(line)
        if not is_completed then
          return
        end

        -- Find task boundaries (including continuations)
        local task_end = get_task_end_line(current_line_num - 1)
        local task_lines = vim.api.nvim_buf_get_lines(0, current_line_num - 1, task_end + 1, false)

        -- Find where to move the task
        local destination = find_list_bottom(current_line_num, level, is_dash)

        -- If already at bottom, don't move
        if destination <= task_end + 1 then
          return
        end

        -- Delete task from original position
        vim.api.nvim_buf_set_lines(0, current_line_num - 1, task_end + 1, false, {})

        -- Adjust destination if it was below the deleted lines
        local lines_removed = task_end - current_line_num + 2
        local insert_pos = destination - lines_removed

        -- Insert task at new position
        vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, task_lines)

        -- Move cursor to the moved task
        vim.api.nvim_win_set_cursor(0, {insert_pos + 1, cursor_pos[2]})
      end

      -- Mark task as done and move to bottom
      local function mark_done_and_move_down()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_line_num = cursor_pos[1]
        local line = vim.api.nvim_buf_get_lines(0, current_line_num - 1, current_line_num, false)[1]

        -- Check if this is a task line and get its format
        local stars, checkbox, star_content = line:match("^(%*+)%s*(%b())%s*(.*)$")
        local indent, dash_content
        if not stars then
          indent, checkbox, dash_content = line:match("^(%s*)%-%s*(%b())%s*(.*)$")
        end

        -- Not a task, do nothing
        if not checkbox then
          return
        end

        local is_asterisk = stars ~= nil
        local task_content = is_asterisk and star_content or dash_content
        local level = is_asterisk and #stars or #indent

        -- Mark as done
        local new_line
        if is_asterisk then
          new_line = stars .. " (x) " .. task_content
        else
          new_line = indent .. "- (x) " .. task_content
        end
        vim.api.nvim_set_current_line(new_line)

        -- Find task boundaries (including continuations)
        local task_end = get_task_end_line(current_line_num - 1)
        local task_lines = vim.api.nvim_buf_get_lines(0, current_line_num - 1, task_end + 1, false)

        -- Update the first line to have the done marker
        task_lines[1] = new_line

        -- Find where to move the task (bottom of current list)
        local destination = find_list_bottom(current_line_num, level, not is_asterisk)

        -- If already at bottom, don't move
        if destination <= task_end + 1 then
          return
        end

        -- Delete task from original position
        vim.api.nvim_buf_set_lines(0, current_line_num - 1, task_end + 1, false, {})

        -- Adjust destination if it was below the deleted lines
        local lines_removed = task_end - current_line_num + 2
        local insert_pos = destination - lines_removed

        -- Insert task at new position
        vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, task_lines)

        -- Move cursor to the moved task
        vim.api.nvim_win_set_cursor(0, {insert_pos + 1, cursor_pos[2]})
      end

      -- Mark task as important and move to top
      local function find_list_top(task_start_line, task_level, is_dash)
        local top = task_start_line

        for i = task_start_line - 1, 1, -1 do
          local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

          -- Skip empty lines
          if line:match("^%s*$") then
            goto continue
          end

          -- Skip continuation lines (lines that are preceded by a line ending with backslash)
          if i > 1 then
            local prev_line = vim.api.nvim_buf_get_lines(0, i - 2, i - 1, false)[1]
            if prev_line and prev_line:match("\\%s*$") then
              goto continue
            end
          end

          if is_dash then
            -- For dash tasks, stop at any heading
            if line:match("^%*+") then
              break
            end
            top = i
          else
            -- For asterisk tasks, stop at parent level or same-level heading without checkbox
            local stars = line:match("^(%*+)")
            if stars then
              if #stars < task_level then
                -- Parent level heading, stop here
                break
              elseif #stars == task_level then
                -- Same level - check if it's a task or heading
                if not line:match("^%*+%s*%b()") then
                  -- Same-level heading without checkbox, stop here
                  break
                end
              end
            end
            top = i
          end

          ::continue::
        end

        return top
      end

      local function mark_important_and_move_up()
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_line_num = cursor_pos[1]
        local line = vim.api.nvim_buf_get_lines(0, current_line_num - 1, current_line_num, false)[1]

        -- Check if this is a task line and get its format
        local stars, checkbox, star_content = line:match("^(%*+)%s*(%b())%s*(.*)$")
        local indent, dash_content
        if not stars then
          indent, checkbox, dash_content = line:match("^(%s*)%-%s*(%b())%s*(.*)$")
        end

        -- Not a task, do nothing
        if not checkbox then
          return
        end

        local is_asterisk = stars ~= nil
        local task_content = is_asterisk and star_content or dash_content
        local level = is_asterisk and #stars or #indent

        -- If already marked as important, toggle back to unchecked and don't move
        if checkbox == "(!)" then
          local new_line
          if is_asterisk then
            new_line = stars .. " ( ) " .. task_content
          else
            new_line = indent .. "- ( ) " .. task_content
          end
          vim.api.nvim_set_current_line(new_line)
          return
        end

        -- Mark as important
        local new_line
        if is_asterisk then
          new_line = stars .. " (!) " .. task_content
        else
          new_line = indent .. "- (!) " .. task_content
        end
        vim.api.nvim_set_current_line(new_line)

        -- Find task boundaries (including continuations)
        local task_end = get_task_end_line(current_line_num - 1)
        local task_lines = vim.api.nvim_buf_get_lines(0, current_line_num - 1, task_end + 1, false)

        -- Update the first line to have the important marker
        task_lines[1] = new_line

        -- Find where to move the task (top of current list)
        local destination = find_list_top(current_line_num, level, not is_asterisk)

        -- If already at top, don't move
        if destination >= current_line_num then
          return
        end

        -- Delete task from original position
        vim.api.nvim_buf_set_lines(0, current_line_num - 1, task_end + 1, false, {})

        -- Insert task at new position (top of list)
        vim.api.nvim_buf_set_lines(0, destination - 1, destination - 1, false, task_lines)

        -- Move cursor to the moved task
        vim.api.nvim_win_set_cursor(0, {destination, cursor_pos[2]})
      end

      -- Generic function to set task state
      local function set_task_state(state_marker, state_name)
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local current_line_num = cursor_pos[1]
        local line = vim.api.nvim_buf_get_lines(0, current_line_num - 1, current_line_num, false)[1]

        -- Check if this is a task line and get its format
        local stars, checkbox, star_content = line:match("^(%*+)%s*(%b())%s*(.*)$")
        local indent, dash_content
        if not stars then
          indent, checkbox, dash_content = line:match("^(%s*)%-%s*(%b())%s*(.*)$")
        end

        -- Not a task, do nothing
        if not checkbox then
          return
        end

        local is_asterisk = stars ~= nil
        local task_content = is_asterisk and star_content or dash_content

        -- Set the new state
        local new_line
        if is_asterisk then
          new_line = stars .. " " .. state_marker .. " " .. task_content
        else
          new_line = indent .. "- " .. state_marker .. " " .. task_content
        end
        vim.api.nvim_set_current_line(new_line)
      end

      -- Keybindings for task state changes with auto-move
      -- Wait for neorg to load, then override its keybinds with auto-move versions
      vim.schedule(function()
        vim.keymap.set("n", "<LocalLeader>td", mark_done_and_move_down, {
          buffer = 0,
          silent = true,
          desc = "Mark task as done (x) and move to bottom"
        })

        vim.keymap.set("n", "<LocalLeader>ti", mark_important_and_move_up, {
          buffer = 0,
          silent = true,
          desc = "Mark task as important (!) and move to top"
        })

        -- Other task states (without auto-move)
        vim.keymap.set("n", "<LocalLeader>tu", function() set_task_state("( )", "undone") end, {
          buffer = 0,
          silent = true,
          desc = "Mark task as undone ( )"
        })

        vim.keymap.set("n", "<LocalLeader>tp", function() set_task_state("(-)", "pending") end, {
          buffer = 0,
          silent = true,
          desc = "Mark task as pending (-)"
        })

        vim.keymap.set("n", "<LocalLeader>th", function() set_task_state("(=)", "on hold") end, {
          buffer = 0,
          silent = true,
          desc = "Mark task as on hold (=)"
        })

        vim.keymap.set("n", "<LocalLeader>tc", function() set_task_state("(_)", "cancelled") end, {
          buffer = 0,
          silent = true,
          desc = "Mark task as cancelled (_)"
        })

        vim.keymap.set("n", "<LocalLeader>tr", function() set_task_state("(+)", "recurring") end, {
          buffer = 0,
          silent = true,
          desc = "Mark task as recurring (+)"
        })

        vim.keymap.set("n", "<LocalLeader>ta", function() set_task_state("(?)", "ambiguous") end, {
          buffer = 0,
          silent = true,
          desc = "Mark task as ambiguous (?)"
        })
      end)
    '';
  };
}
