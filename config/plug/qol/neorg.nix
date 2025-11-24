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
      "core.esupports.hop" = {
        config = {
          external_file_mode = "split";
        };
      };
      "external.interim-ls" = {
        config = {
          completion_provider = {
            enable = true;
            documentation = true;
          };
          goto_definition_provider = {
            enable = true;
          };
        };
      };
    };
  };
}
