{ lib, config, ... }:
{
  plugins.toggleterm = {
    enable = true;
    settings = {
      shade_terminals = false;
      open_mapping = "[[<C-\\>]]";
      on_open = ''
                function(_)
                  local name = vim.fn.bufname("neo-tree")
                  local winnr = vim.fn.bufwinnr(name)

                  if winnr == 1 then
                    vim.defer_fn(function()
                      local cmd = string.format("Neotree toggle")
                      vim.cmd(cmd)
                      vim.cmd(cmd)
                      vim.cmd("wincmd p")
                    end, 100)
                  end

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
