{ lib, ... }: {
  imports = [
    ./autocmds.nix
    ./colorscheme.nix
    ./keys.nix
    ./opts.nix
    ./ftplugin.nix
    ./plug/git/gitlinker.nix
    ./plug/git/gitsigns.nix
    ./plug/treesitter/treesitter-context.nix
    ./plug/treesitter/treesitter.nix
    ./plug/ui/indent-blankline.nix
    ./plug/ui/telescope.nix
    ./plug/ui/todo-comments.nix
    ./plug/utils/autosave.nix
    ./plug/utils/betterescape.nix
    ./plug/utils/colorizer.nix
    ./plug/utils/hardtime.nix
    ./plug/utils/precognition.nix
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
