{
  plugins.gitsigns = {
    enable = true;
    settings = {
      sign_priority=100;
      signs = {
        add = { text = "┃"; };
        change = { text = "┃"; };
        delete = { text = "_"; };
        topdelete = { text = "‾"; };
        changedelete = { text = "~"; };
        untracked = { text = "┃"; };
      };
    };
  };
}
