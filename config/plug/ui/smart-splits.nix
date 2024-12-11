{
  plugins.smart-splits = { enable = true; };
  keymaps = [
    {
      mode = "n";
      key = "<C-h>";
      action = ":lua require('smart-splits').move_cursor_left()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<C-j>";
      action = ":lua require('smart-splits').move_cursor_down()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<C-k>";
      action = ":lua require('smart-splits').move_cursor_up()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<C-l>";
      action = ":lua require('smart-splits').move_cursor_right()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<M-h>";
      action = ":lua require('smart-splits').resize_left()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<M-j>";
      action = ":lua require('smart-splits').resize_down()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<M-k>";
      action = ":lua require('smart-splits').resize_up()<CR>";
      options.silent = true;
    }
    {
      mode = "n";
      key = "<M-l>";
      action = ":lua require('smart-splits').resize_right()<CR>";
      options.silent = true;
    }
  ];
}
