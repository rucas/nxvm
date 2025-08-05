{ config, helpers, ... }:
let
  colors = import ../../../colors/${config.theme}.nix;
  treeWidth = helpers.mkRaw ''
    function()
      local name = vim.fn.bufname("neo-tree")
      local winnr = vim.fn.bufwinnr(name)
      local tree_width = vim.fn.winwidth(winnr)
      return string.rep(" ", tree_width)
    end'';
  moon = helpers.mkRaw ''
    function()
      local chars = setmetatable({
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
        " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
      }, { __index = function() return " " end })
      local line_ratio = vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0)
      local position = math.floor(line_ratio * 100)

      local icon = chars[math.floor(line_ratio * #chars)] .. position
      if position <= 5 then
        icon = " TOP"
      elseif position >= 95 then
        icon = " BOT"
      end
      return icon
    end
  '';
in
{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        component_separators = "";
        section_separators = {
          left = "";
          right = "";
        };
        theme = {
          normal = {
            a = {
              fg = colors.base05;
              bg = colors.base01;
            };
            b = {
              fg = colors.base05;
              bg = colors.base01;
            };
            c = {
              fg = colors.base05;
              bg = colors.base01;
            };
            z = {
              fg = colors.base05;
              bg = colors.base01;
            };
            y = {
              fg = colors.base05;
              bg = colors.base01;
            };
          };
        };
      };
      inactive_sections = {
        lualine_x = [ "filename" ];
      };
      sections = {
        lualine_a = [
          {
            __unkeyed = treeWidth;
            padding = {
              left = 0;
              right = 0;
            };
          }
        ];
        lualine_b = [
          {
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
            padding = {
              left = 1;
              right = 1;
            };
          }
        ];
        lualine_c = [
          {
            __unkeyed_1 = "filetype";
            icon_only = true;
            colored = false;
            padding = {
              left = 1;
              right = 0;
            };
            color = {
              fg = colors.base05;
            };
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
            color = {
              fg = colors.base0E;
            };
          }
        ];
        lualine_x = [
          {
            __unkeyed_1 = "diagnostics";
            sources = [ "nvim_lsp" ];
            symbols = {
              error = "E";
              warn = "W";
              info = "I";
              hint = "H";
            };
          }
        ];
        lualine_y = [ { } ];
        lualine_z = [
          {
            __unkeyed_2 = "location";
            color = {
              fg = colors.faded_green;
            };
          }
          {
            __unkeyed_1 = moon;
            color = {
              fg = colors.faded_blue;
            };
          }

        ];
      };
      extensions = [
        {
          sections = {
            lualine_a = [
              {
                __unkeyed = treeWidth;
                color = {
                  bg = colors.base01;
                  fg = colors.base05;
                };
                padding = {
                  left = 0;
                  right = 0;
                };
              }
            ];
            lualine_b = [
              {
                __unkeyed_1 = "mode";
                fmt = helpers.mkRaw ''
                  function(str)
                    return " " .. "NEOTREE"
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
                    return { fg = mode_color[vim.fn.mode()], gui = "italic,bold" }
                  end
                '';
                padding = {
                  left = 1;
                  right = 1;
                };
              }
            ];
            lualine_c = [ { } ];
            lualine_x = [ { } ];
            lualine_y = [
              {
                __unkeyed = "branch";
                icon = " ";
                fmt = helpers.mkRaw ''
                  function(str)
                    return "[" .. str .. "]"
                  end
                '';

              }
            ];
            lualine_z = [ { } ];
          };
          filetypes = [ "neo-tree" ];
        }
        {
          sections = {
            lualine_a = [
              {
                __unkeyed = treeWidth;
                color = {
                  bg = colors.base01;
                  fg = colors.base05;
                };
                padding = {
                  left = 0;
                  right = 0;
                };
              }
            ];
            lualine_b = [
              {
                __unkeyed_1 = "mode";
                fmt = helpers.mkRaw ''
                  function(str)
                    return " " .. string.sub(str, 1, 4)
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
                    return { fg = mode_color[vim.fn.mode()], gui = "italic,bold" }
                  end
                '';
                padding = {
                  left = 1;
                  right = 1;
                };
              }
            ];
            lualine_c = [ { } ];
            lualine_x = [ { } ];
            lualine_y = [
              {
                __unkeyed = "branch";
                icon = " ";
                fmt = helpers.mkRaw ''
                  function(str)
                    return "[" .. str .. "]"
                  end
                '';

              }
            ];
            lualine_z = [ { } ];
          };
          filetypes = [ "toggleterm" ];
        }
      ];
    };
  };
}
