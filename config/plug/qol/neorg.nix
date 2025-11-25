{ self', ... }:
{
  extraPlugins = [
    self'.packages.neorg-interim-ls
  ];

  extraConfigLua = '''';

  plugins.neorg = {
    enable = true;
    settings.load = {
      "core.defaults" = {
        __empty = null;
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
