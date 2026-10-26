{ lib, config, ... }:
{
  plugins.toggleterm = {
    enable = true;
    settings = {
      shade_terminals = false;
      open_mapping = "[[<C-\\>]]";
      on_open = ''
        function(term)
          vim.defer_fn(function()
            if not vim.api.nvim_win_is_valid(term.window) then
              return
            end

            -- By filetype, not by name: a name pattern of "neo-tree" also
            -- matches an ordinary buffer such as this repo's neo-tree.nix, and
            -- matches nothing at all when the tree has never been opened --
            -- bufwinnr("") then resolves to the terminal's own window, which
            -- is what used to get dragged to the far left and shrunk to 40.
            local tree
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
                tree = win
                break
              end
            end

            if not tree then
              vim.cmd("Neotree show")
              return
            end

            -- Pin the tree full-height on the far left so the terminal spans
            -- only the editing area, then hand focus back to the terminal.
            vim.api.nvim_set_current_win(tree)
            vim.cmd("wincmd H")
            vim.cmd("vertical resize 40")
            vim.api.nvim_set_current_win(term.window)
          end, 50)

          vim.keymap.set("t", "<C-w>", function()
            vim.fn.feedkeys("\x0c", "n")
            vim.opt_local.scrollback = 1
            vim.api.nvim_command("startinsert")
            vim.api.nvim_feedkeys("clear", "t", false)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<cr>", true, false, true), "t", true)
            vim.opt_local.scrollback = 100000
          end, { buffer = 0, silent = true })
        end
      '';
    };
  };
  userCommands = lib.mkIf config.plugins.toggleterm.enable {
    "GitUI" = {
      command.__raw = ''
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local gitui = Terminal:new({
              cmd = "gitui",
              dir = "git_dir",
              direction = "float",
              float_opts = {
                  width = 175,
                  height = 40,
              },
              on_open = function(_) end,
              hidden = true,
          })
          gitui:toggle()
        end
      '';
      nargs = 0;
    };
  };
  keymaps = lib.mkIf config.plugins.toggleterm.enable [
    {
      mode = [ "n" ];
      key = "<leader>Tg";
      action = "<cmd>GitUI<cr>";
      options = {
        desc = "GitUI";
      };
    }
  ];
}
