{ self', ... }:
{
  extraPlugins = [
    self'.packages.neorg-interim-ls
  ];

  extraConfigLua = ''
    vim.tbl_islist = vim.tbl_islist or vim.islist

    do
      local orig_open = vim.ui.open
      vim.ui.open = function(uri, ...)
        local session = type(uri) == "string" and uri:match("^tmux:(.+)$")
        if not session then
          return orig_open(uri, ...)
        end
        vim.system({ "tmux", "has-session", "-t", "=" .. session }, {}, function(res)
          if res.code ~= 0 then
            vim.schedule(function()
              vim.notify("tmux: no session '" .. session .. "'", vim.log.levels.ERROR)
            end)
            return
          end
          vim.system({
            "sh", "-c",
            [[if [ -n "$TMUX" ]; then tmux switch-client -t "$1"; ]]
              .. [[else tmux attach -t "$1"; fi]],
            "sh", session,
          })
        end)
        return true
      end
    end
  '';

  plugins.neorg = {
    enable = true;
    settings.load = {
      "core.defaults" = {
        __empty = null;
      };
      "core.keybinds" = {
        config = {
          default_keybinds = true;
          preset = "neorg";
        };
      };
      "core.dirman" = {
        config = {
          workspaces = {
            ledger = "~/Code/ledger";
          };
          default_workspace = "ledger";
        };
      };
      "core.concealer" = {
        config = {
          folds = true;
          icon_preset = "basic";
          icons = {
            heading = {
              icons = [
                "◉"
                "◎"
                "○"
                "⊛"
                "¤"
                "∘"
              ];
            };
            todo = {
              pending = {
                icon = "◐";
              };
              uncertain = {
                icon = "?";
              };
              urgent = {
                icon = "!";
              };
              on_hold = {
                icon = "⏸";
              };
              cancelled = {
                icon = "_";
              };
              done = {
                icon = "●";
              };
              recurring = {
                icon = "+";
              };
            };
          };
        };
      };
      "core.completion" = {
        config = {
          engine = {
            module_name = "external.lsp-completion";
          };
        };
      };
      "external.interim-ls" = {
        config = {
          completion_provider = {
            enable = true;
            documentation = true;
          };
        };
      };
    };
  };
}
