{
  plugins.smart-splits = {
    enable = true;
  };
  # <cmd> rather than : so the same mapping works from terminal mode without
  # typing a colon into the shell.
  keymaps = [
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-h>";
      action = "<cmd>lua require('smart-splits').move_cursor_left()<cr>";
      options = {
        silent = true;
        desc = "Move to left window";
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-j>";
      action = "<cmd>lua require('smart-splits').move_cursor_down()<cr>";
      options = {
        silent = true;
        desc = "Move to bottom window";
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-k>";
      action = "<cmd>lua require('smart-splits').move_cursor_up()<cr>";
      options = {
        silent = true;
        desc = "Move to top window";
      };
    }
    {
      mode = [
        "n"
        "t"
      ];
      key = "<C-l>";
      action = "<cmd>lua require('smart-splits').move_cursor_right()<cr>";
      options = {
        silent = true;
        desc = "Move to right window";
      };
    }
    {
      mode = "n";
      key = "<M-h>";
      action = "<cmd>lua require('smart-splits').resize_left()<cr>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<M-j>";
      action = "<cmd>lua require('smart-splits').resize_down()<cr>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<M-k>";
      action = "<cmd>lua require('smart-splits').resize_up()<cr>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<M-l>";
      action = "<cmd>lua require('smart-splits').resize_right()<cr>";
      options.silent = true;
    }
  ];
}
