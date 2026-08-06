{ self', ... }:
{
  extraPlugins = [ self'.packages.claudecode ];

  extraConfigLua = ''
    -- Only setup claudecode in interactive environments
    if vim.fn.has('nvim') == 1 and os.getenv('NIX_BUILD_TOP') == nil then
      pcall(function()
        local setup_opts = {}
        require('claudecode').setup(setup_opts)
      end)
    end
  '';

  # ClaudeCodeTreeAdd reads the entry under the cursor and only works from a
  # tree/picker buffer, so it is buffer-local rather than a global <leader>as.
  # Visual mode is included because neo-tree supports multi-select.
  extraFiles."ftplugin/neo-tree.lua".text = ''
    vim.keymap.set({ "n", "v" }, "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", {
      buffer = 0,
      silent = true,
      desc = "Add file to Claude",
    })
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>ac";
      action = "<cmd>ClaudeCode<cr>";
      options = {
        silent = true;
        desc = "Toggle Claude";
      };
    }
    {
      mode = "n";
      key = "<leader>af";
      action = "<cmd>ClaudeCodeFocus<cr>";
      options = {
        silent = true;
        desc = "Focus Claude";
      };
    }
    {
      mode = "n";
      key = "<leader>ar";
      action = "<cmd>ClaudeCode --resume<cr>";
      options = {
        silent = true;
        desc = "Resume session";
      };
    }
    {
      mode = "n";
      key = "<leader>aC";
      action = "<cmd>ClaudeCode --continue<cr>";
      options = {
        silent = true;
        desc = "Continue session";
      };
    }
    {
      mode = "n";
      key = "<leader>am";
      action = "<cmd>ClaudeCodeSelectModel<cr>";
      options = {
        silent = true;
        desc = "Select model";
      };
    }
    {
      mode = "n";
      key = "<leader>ab";
      action = "<cmd>ClaudeCodeAdd %<cr>";
      options = {
        silent = true;
        desc = "Add current buffer";
      };
    }
    {
      mode = "v";
      key = "<leader>as";
      action = "<cmd>ClaudeCodeSend<cr>";
      options = {
        silent = true;
        desc = "Send selection";
      };
    }
    {
      mode = "n";
      key = "<leader>aa";
      action = "<cmd>ClaudeCodeDiffAccept<cr>";
      options = {
        silent = true;
        desc = "Accept diff";
      };
    }
    {
      mode = "n";
      key = "<leader>ad";
      action = "<cmd>ClaudeCodeDiffDeny<cr>";
      options = {
        silent = true;
        desc = "Deny diff";
      };
    }
    {
      mode = "n";
      key = "<leader>aS";
      action = "<cmd>ClaudeCodeStatus<cr>";
      options = {
        silent = true;
        desc = "Status";
      };
    }
  ];
}
