{ lib, ... }: {
  imports = [
    ./autocmds.nix
    ./colorscheme.nix
    ./keys.nix
    ./opts.nix
    ./ftplugin.nix
    ./plug/git/gitlinker.nix
    ./plug/git/gitsigns.nix
    ./plug/lsp/lsp.nix
    ./plug/lsp/trouble.nix
    ./plug/treesitter/treesitter-context.nix
    ./plug/treesitter/treesitter.nix
    ./plug/ui/btw.nix
    ./plug/ui/indent-blankline.nix
    ./plug/ui/neo-tree.nix
    ./plug/ui/smart-splits.nix
    ./plug/ui/telescope.nix
    ./plug/ui/todo-comments.nix
    ./plug/ui/toggleterm.nix
    ./plug/ui/web-devicons.nix
    ./plug/utils/autosave.nix
    ./plug/utils/betterescape.nix
    ./plug/utils/colorizer.nix
    ./plug/utils/hardtime.nix
    ./plug/utils/markview.nix
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
