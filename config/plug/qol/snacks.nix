{
  plugins.snacks = {
    enable = true;
    settings = {
      statuscolumn.enabled = true;
      indent = {
        indent = {
          enabled = true;
          only_scope = true;
          only_current = true;
        };
        animate = {
          enabled = false;
        };
        filter.__raw = ''
          function(buf)
            local filetype = vim.bo[buf].filetype
            -- Exclude norg files
            if filetype == "norg" then
              return false
            end
            return vim.g.snacks_indent ~= false 
              and vim.b[buf].snacks_indent ~= false 
              and vim.bo[buf].buftype == ""
          end
        '';
      };
    };
  };
}
