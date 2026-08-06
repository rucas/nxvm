{ self', ... }:
{
  extraPlugins = [ self'.packages.claudecode ];

  extraConfigLua = ''
    -- Only setup claudecode in interactive environments
    if vim.fn.has('nvim') == 1 and os.getenv('NIX_BUILD_TOP') == nil then
      pcall(function()
        local setup_opts = {
          -- Land in the Claude terminal after <leader>as rather than staying
          -- in the buffer, so a follow-up prompt needs no extra <leader>af.
          focus_after_send = true,
          terminal = {
            -- Spawn at the git root, not Neovim's cwd: opening nvim from a
            -- subdirectory would otherwise hand Claude only that subtree.
            git_repo_cwd = true,
          },
          diff_opts = {
            -- neo-tree is pinned at 40 columns and the Claude split takes
            -- another 30%, so a vertical diff on top leaves too little room.
            open_in_new_tab = true,
          },
        }
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
    {
      mode = "n";
      key = "<leader>a?";
      action = "<cmd>WhichKey t<cr>";
      options = {
        silent = true;
        desc = "Terminal-mode keys";
      };
    }
  ];
}
