{
  config,
  helpers,
  lib,
  pkgs,
  ...
}:
{
  extraPlugins =
    with pkgs.vimPlugins;
    [ blink-ripgrep-nvim ] ++ lib.optionals config.plugins.blink-copilot.enable [ blink-cmp-copilot ];

  extraPackages = with pkgs; [
    gh
    wordnet
  ];

  # Keymaps for snippet navigation
  keymaps = [
    {
      mode = [
        "i"
        "s"
      ];
      key = "<Tab>";
      action = ''
        function()
          if require('blink.cmp').is_visible() then
            return require('blink.cmp').accept()
          elseif require('luasnip').expand_or_jumpable() then
            return require('luasnip').expand_or_jump()
          else
            return "<Tab>"
          end
        end
      '';
      lua = true;
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = [
        "i"
        "s"
      ];
      key = "<S-Tab>";
      action = ''
        function()
          if require('luasnip').jumpable(-1) then
            return require('luasnip').jump(-1)
          else
            return "<S-Tab>"
          end
        end
      '';
      lua = true;
      options = {
        expr = true;
        silent = true;
      };
    }
  ];

  plugins = {
    # Enable LuaSnip
    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
    };

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
        keymap = {
          preset = "super-tab";
        };
        signature = {
          enabled = true;
        };

        snippets = {
          expand = helpers.mkRaw ''
            function(snippet)
              require('luasnip').lsp_expand(snippet)
            end
          '';
          active = helpers.mkRaw ''
            function(filter)
              if filter and filter.direction then
                return require('luasnip').jumpable(filter.direction)
              end
              return require('luasnip').in_snippet()
            end
          '';
          jump = helpers.mkRaw ''
            function(direction)
              require('luasnip').jump(direction)
            end
          '';
        };

        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            (lib.mkIf config.plugins.blink-copilot.enable "copilot")
            "buffer"
            "dictionary"
            "emoji"
            "git"
            "spell"
            "ripgrep"
          ];
          providers = {
            buffer = {
              max_items = 50; # Limit buffer completions
            };
            ripgrep = {
              async = true;
              name = "Ripgrep";
              module = "blink-ripgrep";
              score_offset = 1;
              opts = {
                backend.ripgrep.additional_rg_options = [
                  "--max-count=20"
                  "--type-not=log"
                  "--type-not=binary"
                  "--iglob=!*.min.js"
                ];
              };
            };
            snippets = {
              name = "snippets";
              module = "blink.cmp.sources.snippets";
              opts = {
                friendly_snippets = true;
                search_paths = [ "${pkgs.vimPlugins.friendly-snippets}" ];
              };
            };
            dictionary = {
              name = "Dict";
              enabled = helpers.mkRaw ''
                function()
                  return vim.bo.filetype == 'markdown' or vim.bo.filetype == 'norg'
                end
              '';
              module = "blink-cmp-dictionary";
              # Only trigger on longer words
              min_keyword_length = 4;
              max_items = 20;
              opts = {
                dictionary_files.__raw = ''
                  function()
                      if vim.bo.filetype == 'markdown' or vim.bo.filetype == 'norg' then
                          return { vim.fn.expand('~/.local/share/dict/words') }
                      end
                      return nil
                  end
                '';
              };
            };
            emoji = {
              name = "Emoji";
              module = "blink-emoji";
              score_offset = 1;
            };
            lsp = {
              score_offset = 4;
            };
            spell = {
              name = "Spell";
              module = "blink-cmp-spell";
              score_offset = 1;
            };
            git = {
              module = "blink-cmp-git";
              enabled = helpers.mkRaw ''
                function()
                  return vim.fn.isdirectory('.git') == 1 and vim.bo.filetype ~= 'norg'
                end
              '';
              name = "git";
              score_offset = 100;
              opts = {
                commit = { };
                git_centers = {
                  git_hub = { };
                };
              };
            };
          }
          // lib.optionalAttrs config.plugins.blink-copilot.enable {
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
            prefetch_on_insert = false;
            show_in_snippet = false;
          };
          documentation = {
            auto_show = true;
            window = {
              border = "single";
            };
            treesitter_highlighting = true;
          };
          accept = {
            auto_brackets = {
              enabled = false;
            };
          };
        };
      };
    };
  };
}
