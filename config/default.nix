{ lib, ... }: {
  imports =
    [ ./autocmds.nix ./colorscheme.nix ./keys.nix ./opts.nix ./ftplugin.nix ];

  options = {
    theme = lib.mkOption {
      default = lib.mkDefault "gruvbox";
      type = lib.types.enum [ "gruvbox" ];
    };
  };

  config = { theme = "gruvbox"; };
}
