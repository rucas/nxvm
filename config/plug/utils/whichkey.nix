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
        # Leaf commands: `desc` comes from the keymap in config/keys.nix.
        # Only the icon is attached here -- `group` would render them as
        # empty prefix groups.
        {
          __unkeyed-1 = "<leader>:";
          mode = "n";
          icon = {
            color = "purple";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader>/";
          mode = "n";
          icon = {
            color = "purple";
            icon = " ";
          };
        }
        {
          __unkeyed-1 = "<leader>a";
          mode = [
            "n"
            "v"
          ];
          group = "+ai [claude]";
          icon = {
            color = "green";
            icon = "󰚩 ";
          };
        }
        # Documentation-only entries. which-key installs no trigger in terminal
        # mode (default triggers are "nxso"), so these are never popped up by
        # typing -- they exist so `<leader>a?` / `:WhichKey t` can list them.
        {
          __unkeyed-1 = "<Esc><Esc>";
          mode = "t";
          desc = "Normal mode (snacks/Claude: single <Esc> goes through)";
          icon = {
            color = "yellow";
            icon = "󰊷 ";
          };
        }
        {
          __unkeyed-1 = "<C-\\><C-n>";
          mode = "t";
          desc = "Normal mode (works in any terminal)";
          icon = {
            color = "yellow";
            icon = "󰊷 ";
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
