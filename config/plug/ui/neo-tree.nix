{
  plugins.neo-tree = {
    enable = true;
    extraOptions = {
      filesystem = {
        use_libuv_file_watcher = true;
        scan_mode = "deep";
        follow_current_file = {
          enabled = true;
        };
      };
      default_component_configs = {
        name = {
          highlight_opened_files = true;
        };
        git_status = {
          symbols = {
            added = "✚";
            modified = "";
            deleted = "✖";
            renamed = "󰁕";
            untracked = "";
            ignored = "";
            unstaged = "󰄱";
            staged = "";
            conflict = "";
          };
        };
      };
      window = {
        mappings = {
          "<space>" = "none";
        };
      };
    };
  };
}
