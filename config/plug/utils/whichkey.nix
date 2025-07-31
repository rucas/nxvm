{
  plugins.which-key = {
    enable = true;
    settings = {
      icons = {
        breadcrumb = "»";
        separator = "│";
        group = "+";
      };
      spec = [
        {
          __unkeyed-1 = "<leader>:";
          mode = "n";
          group = "command history";
          icon = {
            color = "purple";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader>/";
          mode = "n";
          group = "grep";
          icon = {
            color = "purple";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader>c";
          mode = "n";
          group = "+code [LSP]";
          icon = {
            color = "red";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader>e";
          mode = "n";
          group = "+explore";
          icon = {
            color = "purple";
            icon = "󰙅 ";
          };
        }
        {
          __unkeyed-1 = "<leader>f";
          mode = "n";
          group = "+find/file";
          icon = {
            color = "blue";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader>g";
          mode = "n";
          group = "+git";
          icon = {
            color = "orange";
            icon = "󰊢 ";
          };
        }
        {
          __unkeyed-1 = "<leader>q";
          mode = "n";
          group = "+quit/session";
          icon = {
            color = "red";
            icon = "󰈆 ";
          };
        }
        {
          __unkeyed-1 = "<leader>T";
          mode = "n";
          group = "+terminals";
          icon = {
            color = "purple";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader>w";
          mode = "n";
          group = "+windows";
          icon = {
            color = "blue";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader><Tab>";
          mode = "n";
          group = "+tabs";
          icon = {
            color = "purple";
            icon = "󰓩 ";
          };
        }
        {
          __unkeyed-1 = "<leader>x";
          mode = "n";
          group = "+diagnostics";
          icon = {
            color = "orange";
            icon = "  ";
          };
        }
      ];
      preset = "helix";
      layout = {
        align = "center";
        spacing = 4;
      };
      win = {
        height = {
          max = 44;
        };
        padding = [
          1
          1
        ];
        # border = "rounded";
        title_pos = "center";
      };
    };
  };
}
