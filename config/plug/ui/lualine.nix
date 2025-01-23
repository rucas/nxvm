{ config, helpers, ... }:
let
  colors = import ../../colors/${config.theme}.nix { };
  treeWidth = helpers.mkRaw ''
    function()
      local name = vim.fn.bufname("neo-tree")
      local winnr = vim.fn.bufwinnr(name)
      local tree_width = vim.fn.winwidth(winnr)
      return string.rep(" ", tree_width)
    end'';
  scrollbar = helpers.mkRaw ''
    function()
    	local sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
    	local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    	local lines = vim.api.nvim_buf_line_count(0)
    	local i = math.floor((curr_line - 1) / lines * #sbar) + 1
    	return string.rep(sbar[i], 2)
    end
  '';
in {
  plugins.lualine = {
    enable = true;
    settings = {
      globalstatus = true;
      sections = {
        lualine_a = [{
          __unkeyed = treeWidth;
          color = {
            fg = colors.base04;
            bg = "nil";
          };
          padding = {
            left = 0;
            right = 0;
          };
          separator.left = "";
          separator.right = "";
        }];
        lualine_b = [{
          __unkeyed_1 = "mode";
          separator.left = "";
          separator.right = "";
        }];
        lualine_c = [
          {
            __unkeyed_1 = "filetype";
            icon_only = true;
            padding = {
              left = 1;
              right = 0;
            };
            separator.left = "";
            separator.right = "";
          }
          {
            __unkeyed_2 = "filename";
            file_status = true;
            newfile_status = false;
            symbols = {
              modified = "[+]";
              readonly = "[]";
              unnamed = "[No Name]";
              newfile = "[New]";
            };
            separator.left = "";
            separator.right = "";
          }
        ];
        lualine_x = [
          {
            __unkeyed_1 = scrollbar;
            color = {
              bg = colors.faded_blue;
              fg = colors.background;
            };
          }
          {
            __unkeyed_2 = "location";
            color = {
              bg = colors.base0B;
              fg = colors.background;
            };
          }
        ];
        lualine_y = [{
          __unkeyed = "fileformat";
          color = {
            bg = colors.base05;
            fg = colors.background;
          };
          separator.left = "";
          separator.right = "";
        }];
        lualine_z = [{
          __unkeyed = "branch";
          icon = "";
          color = {
            bg = colors.base05;
            fg = colors.background;
          };
          separator.left = "";
          separator.right = "";
        }];
      };
    };
  };
}
