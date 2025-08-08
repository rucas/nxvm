{
  plugins.neo-tree = {
    enable = true;
    extraOptions = {
      use_libuv_file_watcher = true;
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
