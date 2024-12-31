{ lib, config, ... }: {
  plugins.gitlinker = {
    enable = true;
    callbacks = { "github.com" = "get_github_type_url"; };
  };
  keymaps = lib.mkIf config.plugins.gitlinker.enable [
    {
      mode = "n";
      key = "<leader>gY";
      action = "<cmd>lua require('gitlinker').get_repo_url()<cr>";
      options = { desc = "Yank Git URL"; };
    }

    {
      mode = "n";
      key = "<leader>gO";
      action =
        "<cmd>lua require('gitlinker').get_repo_url({action_callback = require('gitlinker.actions').open_in_browser})<cr>";
      options = {
        desc = "Open Git URL";
        silent = true;
      };
    }

  ];
}
