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
          color = { bg = colors.background; };
          padding = {
            left = 0;
            right = 0;
          };
          separator.left = "";
          separator.right = "│";
        }];
        lualine_b = [{
          __unkeyed_1 = "mode";
          fmt = helpers.mkRaw ''
            function(str)
              return " " .. string.sub(str, 1, 3)
            end
          '';
          color = helpers.mkRaw ''
            function()
              local mode_color = {
                  n = '${colors.base08}',
                  i = '${colors.base0B}',
                  v = '${colors.base0D}',
                  [""] = '${colors.base0D}',
                  V = '${colors.base0D}',
                  c = '${colors.base0F}',
                  no = '${colors.base08}',
                  s = '${colors.base09}',
                  S = '${colors.base09}',
                  [""] = '${colors.base09}',
                  ic = '${colors.base0A}',
                  R = '${colors.base0E}',
                  Rv = '${colors.base0E}',
                  cv = '${colors.base08}',
                  ce = '${colors.base08}',
                  r = '${colors.base0C}',
                  rm = '${colors.base0C}',
                  ["r?"] = '${colors.base0C}',
                  ["!"] = '${colors.base08}',
                  t = '${colors.base0E}',
              }
              return { fg = mode_color[vim.fn.mode()] }
            end
          '';
          separator = {
            left = "";
            right = "";
          };
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
