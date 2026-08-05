{
  keymaps = [
    # no op space
    {
      mode = "n";
      key = "<Space>";
      action = "<NOP>";
      options = {
        noremap = true;
      };
    }

    {
      mode = "n";
      key = "<leader>:";
      action = "<cmd>Telescope command_history<cr>";
      options = {
        desc = "command history";
      };
    }

    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope live_grep<cr>";
      options = {
        desc = "grep";
      };
    }

    {
      mode = "n";
      key = "<leader>et";
      action = "<cmd>Neotree toggle<cr>";
      options = {
        desc = "Toggle Neotree";
      };
    }

    {
      mode = "n";
      key = "<leader>eu";
      action = "<cmd>UndotreeToggle<cr>";
      options = {
        desc = "Toggle Undotree";
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<cr>";
      options = {
        desc = "Buffers";
      };
    }

    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options = {
        desc = "Project Files";
      };
    }

    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope git_files<cr>";
      options = {
        desc = "Git Files";
      };
    }

    {
      mode = "n";
      key = "<leader>fo";
      action = "<cmd>Telescope oldfiles<cr>";
      options = {
        desc = "Recent";
      };
    }

    {
      mode = "n";
      key = "<leader>fR";
      action = "<cmd>Telescope resume<cr>";
      options = {
        desc = "Resume";
      };
    }

    # Prefix groups (+debug, +code, +test, ...) belong in plug/utils/whichkey.nix
    # under settings.spec. Declaring them here as `action = "+name"` emits a real
    # keymap that types the literal text, which forces 'timeoutlen' down to hide it.

    {
      mode = "n";
      key = ";";
      action = ":";
    }

    # NOTE: yanks from cursor to end of line
    {
      mode = "n";
      key = "<leader>YY";
      action = ''
        "+y$
      '';
      options = {
        desc = "Copy to system clipboard";
      };
    }
    {
      mode = "v";
      key = "<leader>YY";
      action = ''
        "+y
      '';
      options = {
        desc = "Copy to system clipboard";
      };
    }

    # Windows
    {
      mode = "n";
      key = "<leader>ww";
      action = "<C-W>p";
      options = {
        silent = true;
        desc = "Other window";
      };
    }

    {
      mode = "n";
      key = "<leader>wd";
      action = "<C-W>c";
      options = {
        silent = true;
        desc = "Delete window";
      };
    }

    {
      mode = "n";
      key = "<leader>w-";
      action = "<C-W>s";
      options = {
        silent = true;
        desc = "Split window below";
      };
    }

    {
      mode = "n";
      key = "<leader>w|";
      action = "<C-W>v";
      options = {
        silent = true;
        desc = "Split window right";
      };
    }

    # <C-hjkl> window movement lives in plug/ui/smart-splits.nix so it can hand
    # off to the surrounding tmux pane at the edge of the window layout.

    # Tabs
    {
      mode = "n";
      key = "<leader><tab><tab>";
      action = "<cmd>tabnew<cr>";
      options = {
        silent = true;
        desc = "New Tab";
      };
    }

    {
      mode = "n";
      key = "<leader><tab>d";
      action = "<cmd>tabclose<cr>";
      options = {
        silent = true;
        desc = "Close tab";
      };
    }

    # Quit/Session
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>quitall!<cr><esc>";
      options = {
        silent = true;
        desc = "Quit all";
      };
    }

    # Terminal
    {
      mode = "t";
      key = "<esc>";
      action = "<C-\\><C-n>";
      options = {
        silent = true;
      };
    }
  ];
}
