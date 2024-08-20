{ lib, ... }: {
  imports = [
    ./autocmds.nix
    ./colorscheme.nix
    ./keys.nix
    ./opts.nix
    ./ftplugin.nix
    ./plug/ui/telescope.nix
    ./plug/utils/autosave.nix
    ./plug/utils/betterescape.nix
    ./plug/utils/colorizer.nix
    ./plug/utils/hardtime.nix
    ./plug/utils/undotree.nix
    ./plug/utils/whichkey.nix
  ];

  options = {
    theme = lib.mkOption {
      default = lib.mkDefault "gruvbox";
      type = lib.types.enum [ "gruvbox" ];
    };
  };

  config = { theme = "gruvbox"; };
}
