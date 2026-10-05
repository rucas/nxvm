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
    -- is a line number from before the cut. Returns the line the block landed
    -- on, so a caller can keep acting on it.
    local function move_block(buf, first, last, anchor, block)
      vim.api.nvim_buf_set_lines(buf, first - 1, last, false, {})
      local insert_at = anchor > last and (anchor - (last - first + 1)) or anchor
      vim.api.nvim_buf_set_lines(buf, insert_at, insert_at, false, block)
      local win = vim.fn.bufwinid(buf)
      if win ~= -1 then
        vim.api.nvim_win_set_cursor(win, { insert_at + 1, 0 })
      end
      return insert_at + 1
    end

    -- Line of the "*** ( ) TODO" under the "** <DAY> <date>" section, plus the
    -- day heading itself. Both nil when the file has no section for that date.
    local function find_day_todo(lines, date)
      for i = 1, #lines do
        if heading_level(lines[i]) == 2 and lines[i]:match(vim.pesc(date) .. "%s*$") then
          return child_heading(lines, i, "^%*%*%*%s*%b()%s*TODO%s*$"), i
        end
      end
    end

    -- Loaded buffer for the ledger month owning `date`, derived from the source
    -- file's own path (<root>/<YYYY>/<MM>.norg). Generates the month with
    -- `ldgr gen month` when it does not exist yet.
    local function month_buffer(source_buf, date)
      local src = vim.api.nvim_buf_get_name(source_buf)
      local root = src:match("^(.*)/%d%d%d%d/%d%d%.norg$")
      if not root then
        return fail("Not a <year>/<month>.norg ledger file, cannot resolve sibling months")
      end

      local year, month = date:match("^(%d%d%d%d)-(%d%d)-")
      local path = ("%s/%s/%s.norg"):format(root, year, month)

      if not vim.uv.fs_stat(path) then
        -- `ldgr gen month` redirects over its output file, so it must only ever
        -- run for a month that is absent -- otherwise it would truncate it.
        local ldgr = root .. "/scripts/ldgr"
        if not vim.uv.fs_stat(ldgr) then
          return fail(("No %s, and no scripts/ldgr to generate it"):format(path))
        end
        local res = vim.system(
          { ldgr, "gen", "month", tostring(tonumber(month)), year },
          { cwd = root, text = true }
        ):wait()
        if res.code ~= 0 or not vim.uv.fs_stat(path) then
          return fail(("ldgr gen month %s %s failed: %s"):format(
            tonumber(month), year, vim.trim((res.stderr or "") .. (res.stdout or ""))))
        end
        vim.notify("Generated " .. vim.fn.fnamemodify(path, ":~"))
      end

      local buf = vim.fn.bufadd(path)
      vim.fn.bufload(buf)
      return buf, path
    end

    -- Move the "*** item" at `row` out of its "** INBOX" and into the
    -- "*** ( ) TODO" list of the "** <DAY> <date>" section, as a
    -- "**** ( ) item" at the top of that list. `date` is "YYYY-MM-DD".
    --
    -- When the date belongs to another month the item crosses into that file,
    -- which is generated first if it does not exist.
    --
    -- buf and row are explicit because the calendar picker resolves them
    -- before opening, then acts on them asynchronously.
    --
    -- Returns the buffer and line the task landed on (which is not the source
    -- buffer when the date crossed into another month), or nil on failure.
    local function inbox_item_to_date(buf, row, date)
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      local item_start = owning_heading(lines, row, 3)
      local inbox = item_start and owning_heading(lines, item_start - 1, 2)
      if not inbox or not lines[inbox]:match("^%*%*%s+INBOX%s*$") then
        return fail("Cursor is not on an INBOX item")
      end

      local item_end = block_end(lines, item_start, 3)
      local block = vim.list_slice(lines, item_start, item_end)
      local text, checkbox = heading_text(block[1])
      block[1] = "**** " .. (checkbox or "( )") .. " " .. text
      -- The item gained a level, so any headings it owns gain one too.
      for i = 2, #block do
        block[i] = block[i]:gsub("^(%*+)%s", "%1* ")
      end

      local todo_line, day_line = find_day_todo(lines, date)
      if day_line then
        if not todo_line then
          return fail("No TODO list under " .. date)
        end
        return buf, move_block(buf, item_start, item_end, todo_line, block)
      end

      local target, path = month_buffer(buf, date)
      if not target then
        return
      end
      if target == buf then
        return fail("No section for " .. date .. " in " .. vim.fn.fnamemodify(path, ":t"))
      end

      local target_todo = find_day_todo(vim.api.nvim_buf_get_lines(target, 0, -1, false), date)
      if not target_todo then
        return fail(("No TODO list for %s in %s"):format(date, vim.fn.fnamemodify(path, ":t")))
      end

      -- Insert before cutting, so a failure above never loses the item.
      vim.api.nvim_buf_set_lines(target, target_todo, target_todo, false, block)
      vim.api.nvim_buf_call(target, function()
        vim.cmd("silent write")
      end)
      vim.api.nvim_buf_set_lines(buf, item_start - 1, item_end, false, {})
      vim.notify(("Scheduled for %s in %s"):format(date, vim.fn.fnamemodify(path, ":t")))
      return target, target_todo + 1
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

    local CLAUDE_READY_TIMEOUT_MS = 15000
    local CLAUDE_POLL_MS = 200

    -- send_to_terminal needs a live pane and does not open one itself. An
    -- already-open pane is sitting at a prompt, so it takes the text straight
    -- away; a cold start has to boot Claude first, and its IDE websocket
    -- handshake is the only readiness signal on offer, so poll for that rather
    -- than writing into a terminal that will drop the bytes.
    local function send_to_claude(text)
      local ok, terminal = pcall(require, "claudecode.terminal")
      if not ok then
        return fail("claudecode.nvim is not loaded")
      end

      if terminal.get_active_terminal_bufnr() then
        terminal.send_to_terminal(text, { focus = true })
        return
      end

      terminal.ensure_visible()

      local claudecode = require("claudecode")
      local waited = 0
      local function poll()
        if claudecode.is_claude_connected() and terminal.get_active_terminal_bufnr() then
          terminal.send_to_terminal(text, { focus = true })
        elseif waited >= CLAUDE_READY_TIMEOUT_MS then
          fail("Claude did not come up in time; the task was not sent")
        else
          waited = waited + CLAUDE_POLL_MS
          vim.defer_fn(poll, CLAUDE_POLL_MS)
        end
      end
      vim.defer_fn(poll, CLAUDE_POLL_MS)
    end

    -- Hand the "**** ( ) task" under the cursor to the ledger's /execute-task
    -- skill, which gives it a worktree and a tmux session of its own. The whole
    -- task block travels as the brief, so the new session gets the jira:/pr:
    -- lines along with the header, and the local marker moves to (-) because
    -- handing it off is the point at which the work starts.
    --
    -- A "*** item" in a week's INBOX is scheduled onto today on the way, for
    -- the same reason: an agent is working it, so it is no longer a capture.
    function M.execute_task()
      local buf = vim.api.nvim_get_current_buf()
      local row = vim.api.nvim_win_get_cursor(0)[1]
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

      local item_start = owning_heading(lines, row, 3)
      local inbox = item_start and owning_heading(lines, item_start - 1, 2)
      if inbox and lines[inbox]:match("^%*%*%s+INBOX%s*$") then
        buf, row = inbox_item_to_date(buf, row, os.date("%Y-%m-%d"))
        if not buf then
          return
        end
        lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      end

      local task_start = owning_heading(lines, row, 4)
      local todo_line = task_start and owning_heading(lines, task_start - 1, 3)
      if not todo_line or not lines[todo_line]:match("^%*%*%*%s*%b()%s*TODO%s*$") then
        return fail("Cursor is not on a TODO task or an INBOX item")
      end

      local stars, checkbox, text = lines[task_start]:match("^(%*+)%s*(%b())%s*(.*)$")
      if not checkbox or text == "" then
        return fail("Task has no description to execute")
      end

      -- Only the status char moves; any |-separated priority or timestamp
      -- extension inside the checkbox is preserved.
      local in_progress = stars .. " (-" .. checkbox:sub(3, -2) .. ") " .. text
      vim.api.nvim_buf_set_lines(buf, task_start - 1, task_start, false, { in_progress })

      -- inbox_item_to_date already wrote the target when the item crossed into
      -- another month's file, so the marker has to be written after it.
      if buf ~= vim.api.nvim_get_current_buf() then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd("silent write")
        end)
      end

      local block = vim.list_slice(lines, task_start, block_end(lines, task_start, 4))
      block[1] = in_progress
      -- block_end runs to the end of the file when nothing follows the task, so
      -- the trailing blank lines of the day would otherwise ride along.
      while #block > 1 and block[#block]:match("^%s*$") do
        table.remove(block)
      end

      send_to_claude("/execute-task " .. table.concat(block, "\n"))
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
