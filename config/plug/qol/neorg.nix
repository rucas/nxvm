{ self', ... }:
{
  extraPlugins = [
    self'.packages.neorg-interim-ls
  ];

  # Shared by the norg ftplugin (for keymaps) and the neorgcmd module below.
  # It cannot live in the ftplugin: those are per-buffer closures, whereas a
  # neorg module is loaded once and globally.
  extraFiles."lua/ledger.lua".text = ''
    local M = {}

    -- Heading depth of a line, e.g. "*** NOTES" -> 3. nil for body lines.
    local function heading_level(line)
      local stars = line and line:match("^(%*+)%s")
      return stars and #stars
    end

    local function fail(msg)
      vim.notify(msg, vim.log.levels.ERROR)
    end

    -- Nearest heading at or above `depth`, walking up from `row` so that body
    -- and child lines resolve to the item that owns them. nil unless that
    -- heading sits at exactly `depth`.
    local function owning_heading(lines, row, depth)
      for i = row, 1, -1 do
        local level = heading_level(lines[i])
        if level and level <= depth then
          return level == depth and i or nil
        end
      end
    end

    -- Last line of the block owned by the heading at `start`, i.e. everything
    -- up to the next heading that is not nested inside it.
    local function block_end(lines, start, depth)
      for i = start + 1, #lines do
        local level = heading_level(lines[i])
        if level and level <= depth then
          return i - 1
        end
      end
      return #lines
    end

    -- Heading line of the section enclosing `row`, searching up for `depth`
    -- and then down for the first child matching `pattern`.
    local function child_heading(lines, from, pattern)
      local parent = heading_level(lines[from])
      for i = from + 1, #lines do
        local level = heading_level(lines[i])
        if level and level <= parent then
          return nil
        end
        if lines[i]:match(pattern) then
          return i
        end
      end
    end

    -- Text of a heading with its stars and any checkbox stripped.
    local function heading_text(line)
      local text = line:match("^%*+%s*(.-)%s*$")
      local checkbox = text:match("^%b()")
      return checkbox and (text:sub(#checkbox + 1):gsub("^%s*", "")) or text, checkbox
    end

    -- Cut `first..last` and re-insert `block` directly below `anchor`, which
    -- is a line number from before the cut.
    local function move_block(buf, first, last, anchor, block)
      vim.api.nvim_buf_set_lines(buf, first - 1, last, false, {})
      local insert_at = anchor > last and (anchor - (last - first + 1)) or anchor
      vim.api.nvim_buf_set_lines(buf, insert_at, insert_at, false, block)
      local win = vim.fn.bufwinid(buf)
      if win ~= -1 then
        vim.api.nvim_win_set_cursor(win, { insert_at + 1, 0 })
      end
    end

    -- Move the "*** item" at `row` out of its "** INBOX" and into the
    -- "*** ( ) TODO" list of the "** <DAY> <date>" section, as a
    -- "**** ( ) item" at the top of that list. `date` is "YYYY-MM-DD".
    --
    -- buf and row are explicit because the calendar picker resolves them
    -- before opening, then acts on them asynchronously.
    local function inbox_item_to_date(buf, row, date)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      local item_start = owning_heading(lines, row, 3)
      local inbox = item_start and owning_heading(lines, item_start - 1, 2)
      if not inbox or not lines[inbox]:match("^%*%*%s+INBOX%s*$") then
        return fail("Cursor is not on an INBOX item")
      end

      local day_line
      for i = 1, #lines do
        if heading_level(lines[i]) == 2 and lines[i]:match(vim.pesc(date) .. "%s*$") then
          day_line = i
          break
        end
      end
      if not day_line then
        return fail("No section for " .. date .. " in this file")
      end

      local todo_line = child_heading(lines, day_line, "^%*%*%*%s*%b()%s*TODO%s*$")
      if not todo_line then
        return fail("No TODO list under " .. date)
      end

      local item_end = block_end(lines, item_start, 3)
      local block = vim.list_slice(lines, item_start, item_end)
      local text, checkbox = heading_text(block[1])
      block[1] = "**** " .. (checkbox or "( )") .. " " .. text
      -- The item gained a level, so any headings it owns gain one too.
      for i = 2, #block do
        block[i] = block[i]:gsub("^(%*+)%s", "%1* ")
      end

      move_block(buf, item_start, item_end, todo_line, block)
    end

    function M.inbox_to_today()
      inbox_item_to_date(
        vim.api.nvim_get_current_buf(),
        vim.api.nvim_win_get_cursor(0)[1],
        os.date("%Y-%m-%d")
      )
    end

    -- Same, but pick the target day from neorg's calendar. The item is resolved
    -- up front: create_calendar fires the callback while its own window is
    -- still current, so nothing may rely on the norg buffer being focused.
    function M.inbox_to_picked_date()
      local buf = vim.api.nvim_get_current_buf()
      local row = vim.api.nvim_win_get_cursor(0)[1]

      local modules = require("neorg.core").modules
      if not modules.is_module_loaded("core.ui.calendar") then
        return fail("core.ui.calendar is not loaded")
      end

      -- Bail before opening the calendar if the cursor is not on an item, so
      -- the picker is not shown for a move that cannot happen.
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local item_start = owning_heading(lines, row, 3)
      local inbox = item_start and owning_heading(lines, item_start - 1, 2)
      if not inbox or not lines[inbox]:match("^%*%*%s+INBOX%s*$") then
        return fail("Cursor is not on an INBOX item")
      end

      modules.get_module("core.ui.calendar").select_date({
        -- schedule_wrap: the callback runs before the calendar window closes
        callback = vim.schedule_wrap(function(picked)
          if not picked then
            return
          end
          -- Round-trip through os.time so an unnormalised day still resolves.
          local stamp = os.time({ year = picked.year, month = picked.month, day = picked.day })
          inbox_item_to_date(buf, row, os.date("%Y-%m-%d", stamp))
        end),
      })
    end

    -- The inverse: move the "**** (x) task" under the cursor out of its day's
    -- TODO list and back to the top of that week's "** INBOX", as a plain
    -- "*** task". INBOX items carry no checkbox, so the state is dropped.
    function M.task_to_inbox()
      local buf = vim.api.nvim_get_current_buf()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      local task_start = owning_heading(lines, row, 4)
      local todo_line = task_start and owning_heading(lines, task_start - 1, 3)
      if not todo_line or not lines[todo_line]:match("^%*%*%*%s*%b()%s*TODO%s*$") then
        return fail("Cursor is not on a task in a TODO list")
      end

      local week_line = owning_heading(lines, todo_line - 1, 1)
      local inbox_line = week_line and child_heading(lines, week_line, "^%*%*%s+INBOX%s*$")
      if not inbox_line then
        return fail("No INBOX in this week")
      end

      local task_end = block_end(lines, task_start, 4)
      local block = vim.list_slice(lines, task_start, task_end)
      block[1] = "*** " .. heading_text(block[1])
      for i = 2, #block do
        block[i] = block[i]:gsub("^%*(%*+%s)", "%1")
      end

      move_block(buf, task_start, task_end, inbox_line, block)
    end

    return M
  '';

  extraConfigLua = ''
    vim.tbl_islist = vim.tbl_islist or vim.islist

    do
      local orig_open = vim.ui.open
      vim.ui.open = function(uri, ...)
        local session = type(uri) == "string" and uri:match("^tmux:(.+)$")
        if not session then
          return orig_open(uri, ...)
        end
        vim.system({ "tmux", "has-session", "-t", "=" .. session }, {}, function(res)
          if res.code ~= 0 then
            vim.schedule(function()
              vim.notify("tmux: no session '" .. session .. "'", vim.log.levels.ERROR)
            end)
            return
          end
          vim.system({
            "sh", "-c",
            [[if [ -n "$TMUX" ]; then tmux switch-client -t "$1"; ]]
              .. [[else tmux attach -t "$1"; fi]],
            "sh", session,
          })
        end)
        return true
      end
    end

    -- ":Neorg inbox today" / ":Neorg inbox back". neorg dispatches commands as
    -- broadcast events rather than callbacks, so this has to be a real module.
    -- Scheduled because neorg.setup() runs later in this same init.
    vim.schedule(function()
      local modules = require("neorg.core").modules
      if modules.is_module_loaded("external.ledger") then
        return
      end

      local ledger = modules.create("external.ledger")

      ledger.load = function()
        modules.await("core.neorgcmd", function(neorgcmd)
          neorgcmd.add_commands_from_table({
            inbox = {
              min_args = 1,
              max_args = 1,
              condition = "norg",
              subcommands = {
                today = { args = 0, name = "ledger.inbox.today" },
                date = { args = 0, name = "ledger.inbox.date" },
                back = { args = 0, name = "ledger.inbox.back" },
              },
            },
          })
        end)
      end

      ledger.events.subscribed = {
        ["core.neorgcmd"] = {
          ["ledger.inbox.today"] = true,
          ["ledger.inbox.date"] = true,
          ["ledger.inbox.back"] = true,
        },
      }

      ledger.on_event = function(event)
        local actions = require("ledger")
        if event.split_type[2] == "ledger.inbox.today" then
          actions.inbox_to_today()
        elseif event.split_type[2] == "ledger.inbox.date" then
          actions.inbox_to_picked_date()
        elseif event.split_type[2] == "ledger.inbox.back" then
          actions.task_to_inbox()
        end
      end

      modules.load_module_from_table(ledger)
    end)
  '';

  plugins.neorg = {
    enable = true;
    settings.load = {
      "core.defaults" = {
        __empty = null;
      };
      "core.keybinds" = {
        config = {
          default_keybinds = true;
          preset = "neorg";
        };
      };
      "core.dirman" = {
        config = {
          workspaces = {
            ledger = "~/Code/ledger";
          };
          default_workspace = "ledger";
        };
      };
      "core.concealer" = {
        config = {
          folds = true;
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
                icon = "◐";
              };
              uncertain = {
                icon = "?";
              };
              urgent = {
                icon = "!";
              };
              on_hold = {
                icon = "⏸";
              };
              cancelled = {
                icon = "_";
              };
              done = {
                icon = "●";
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
