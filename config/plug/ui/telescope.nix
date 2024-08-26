{
  plugins.telescope = {
    enable = true;
    extensions = {
      file-browser = { enable = true; };
      fzf-native = { enable = true; };
    };
    settings = {
      defaults = {
        prompt_prefix = "";
        entry_prefix = "  ";
        layout_config = {
          horizontal = {
            prompt_position = "top";
            preview_width = 0.55;
            results_width = 0.8;
          };
          vertical = { mirror = false; };
          width = 0.7;
          height = 0.6;
          preview_cutoff = 80;

        };
        border = true;
        sorting_strategy = "ascending";
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "^data/"
          "%.ipynb"
          "node_modules"
          "^.pytest_cache/"
          "^.direnv/"
        ];
        set_env = { COLORTERM = "truecolor"; };
        mappings = {
          n = { "q" = { __raw = "require('telescope.actions').close"; }; };
        };
      };
    };
    keymaps = {
      "<leader>/" = {
        action = "live_grep";
        options = { desc = "Grep (root dir)"; };
      };
      "<leader>:" = {
        action = "command_history";
        options = { desc = "Command History"; };
      };
      "<leader>ff" = {
        action = "find_files";
        options = { desc = "Project files"; };
      };
      "<leader>fg" = {
        action = "git_files";
        options = { desc = "Git files"; };
      };
      "<leader>fR" = {
        action = "resume";
        options = { desc = "Resume"; };
      };
      "<leader>fo" = {
        action = "oldfiles";
        options = { desc = "Recent"; };
      };
      "<leader>fb" = {
        action = "buffers";
        options = { desc = "Buffers"; };
      };
    };
  };
}
