{
  globals.mapleader = " ";
  keymaps = [
    {
      mode = "n";
      key = "<leader>:";
      action = "<cmd>Telescope command_history<cr>";
      options = { desc = "command history"; };
    }

    {
      mode = "n";
      key = "<leader>/";
      action = "<cmd>Telescope live_grep<cr>";
      options = { desc = "grep"; };
    }

    {
      mode = "n";
      key = "<leader>e";
      action = "+explore";
    }

    {
      mode = "n";
      key = "<leader>et";
      action = "<cmd>Neotree toggle<cr>";
      options = { desc = "Toggle Neotree"; };
    }

    {
      mode = "n";
      key = "<leader>eu";
      action = "<cmd>UndotreeToggle<cr>";
      options = { desc = "Toggle Undotree"; };
    }
    {
      mode = "n";
      key = "<leader>f";
      action = "+find/file";
    }

    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<cr>";
      options = { desc = "Buffers"; };
    }

    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<cr>";
      options = { desc = "Project Files"; };
    }

    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Telescope git_files<cr>";
      options = { desc = "Git Files"; };
    }

    {
      mode = "n";
      key = "<leader>fo";
      action = "<cmd>Telescope oldfiles<cr>";
      options = { desc = "Recent"; };
    }

    {
      mode = "n";
      key = "<leader>fR";
      action = "<cmd>Telescope resume<cr>";
      options = { desc = "Resume"; };
    }

    #{
    #  mode = "n";
    #  key = "<leader>d";
    #  action = "+debug";
    #}

    {
      mode = "n";
      key = "<leader>g";
      action = "+git/goto";
    }

    {
      mode = [ "n" "v" ];
      key = "<leader>gy";
      action = "";
      options = { desc = "Yank Git Line"; };
    }

    #{
    #  mode = "n";
    #  key = "<leader>s";
    #  action = "+search";
    #}

    {
      mode = "n";
      key = "<leader>q";
      action = "+quit/session";
    }

    {
      mode = "n";
      key = "<leader>w";
      action = "+windows";
    }

    {
      mode = "n";
      key = "<leader><Tab>";
      action = "+tabs";
    }

    #{
    #  mode = [ "n" "v" ];
    #  key = "<leader>c";
    #  action = "+code";
    #}

    #{
    #  mode = [ "n" "v" ];
    #  key = "<leader>t";
    #  action = "+test";
    #}

    {
      mode = "n";
      key = ";";
      action = ":";
    }

    {
      mode = [ "n" "v" ];
      key = "<leader>YY";
      action = ''
        "+Y
      '';
      options = { desc = "Copy to system clipboard"; };
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

    {
      mode = "n";
      key = "<C-h>";
      action = "<C-W>h";
      options = {
        silent = true;
        desc = "Move to left window";
      };
    }

    {
      mode = "n";
      key = "<C-l>";
      action = "<C-W>l";
      options = {
        silent = true;
        desc = "Move to right window";
      };
    }

    {
      mode = "n";
      key = "<C-k>";
      action = "<C-W>k";
      options = {
        silent = true;
        desc = "Move to top window";
      };
    }

    {
      mode = "n";
      key = "<C-j>";
      action = "<C-W>j";
      options = {
        silent = true;
        desc = "Move to bottom window";
      };
    }

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

  ];
}
