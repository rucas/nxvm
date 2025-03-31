{ config, lib, pkgs, ... }: {
  extraPlugins = with pkgs.vimPlugins;
    [ blink-ripgrep-nvim ]
    ++ lib.optionals config.plugins.blink-copilot.enable [ blink-cmp-copilot ];

  extraPackages = with pkgs; [ gh wordnet ];

  plugins = {
    blink-cmp-copilot.enable = false;
    blink-cmp-dictionary.enable = true;
    blink-cmp-spell.enable = true;
    blink-copilot.enable = false;
    blink-cmp-git.enable = true;
    blink-emoji.enable = true;
    blink-ripgrep.enable = true;
    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        keymap = { preset = "super-tab"; };
        signature = { enabled = true; };

        sources = {
          default = [
            "buffer"
            "lsp"
            "path"
            "snippets"
            (lib.mkIf config.plugins.blink-copilot.enable "copilot")
            "dictionary"
            "emoji"
            "git"
            "spell"
            "ripgrep"
          ];
          providers = {
            ripgrep = {
              name = "Ripgrep";
              module = "blink-ripgrep";
              score_offset = 1;
            };
            dictionary = {
              name = "Dict";
              module = "blink-cmp-dictionary";
              min_keyword_length = 3;
            };
            emoji = {
              name = "Emoji";
              module = "blink-emoji";
              score_offset = 1;
            };
            lsp = { score_offset = 4; };
            spell = {
              name = "Spell";
              module = "blink-cmp-spell";
              score_offset = 1;
            };
            git = {
              module = "blink-cmp-git";
              name = "git";
              score_offset = 100;
              opts = {
                commit = { };
                git_centers = { git_hub = { }; };
              };
            };
          } // lib.optionalAttrs config.plugins.blink-copilot.enable {
            copilot = {
              name = "copilot";
              module = "blink-copilot";
              async = true;
              score_offset = 100;
            };
          };
        };

        appearance = {
          nerd_font_variant = "mono";
          kind_icons = {
            Text = "󰉿";
            Method = "";
            Function = "󰊕";
            Constructor = "󰒓";

            Field = "󰜢";
            Variable = "󰆦";
            Property = "󰖷";

            Class = "󱡠";
            Interface = "󱡠";
            Struct = "󱡠";
            Module = "󰅩";

            Unit = "󰪚";
            Value = "󰦨";
            Enum = "󰦨";
            EnumMember = "󰦨";

            Keyword = "󰻾";
            Constant = "󰏿";

            Snippet = "󱄽";
            Color = "󰏘";
            File = "󰈔";
            Reference = "󰬲";
            Folder = "󰉋";
            Event = "󱐋";
            Operator = "󰪚";
            TypeParameter = "󰬛";
            Error = "󰏭";
            Warning = "󰏯";
            Information = "󰏮";
            Hint = "󰏭";

            Emoji = "🤶";
          };
        };
        completion = {
          ghost_text.enabled = true;
          menu = {
            border = "none";
            draw = {
              gap = 1;
              treesitter = [ "lsp" ];
              columns = [
                { __unkeyed-1 = "label"; }
                {
                  __unkeyed-1 = "kind_icon";
                  __unkeyed-2 = "kind";
                  gap = 1;
                }
                { __unkeyed-1 = "source_name"; }
              ];
            };
          };
          trigger = {
            prefetch_on_insert = true;
            show_in_snippet = false;
          };
          documentation = {
            auto_show = true;
            window = { border = "single"; };
            treesitter_highlighting = true;
          };
          accept = { auto_brackets = { enabled = false; }; };
        };
      };
    };
  };
}

