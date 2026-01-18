{
  description = "A Nix Neovim Flake...";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    precognition = {
      url = "github:tris203/precognition.nvim";
      flake = false;
    };
    btw = {
      url = "github:letieu/btw.nvim";
      flake = false;
    };
    gitlinker = {
      url = "github:linrongbin16/gitlinker.nvim";
      flake = false;
    };
    neorg-overlay = {
      url = "github:nvim-neorg/nixpkgs-neorg-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neorg-interim-ls = {
      url = "github:benlubas/neorg-interim-ls";
      flake = false;
    };
    claudecode = {
      url = "github:coder/claudecode.nvim";
      flake = false;
    };
    tree-sitter-tera = {
      url = "github:uncenter/tree-sitter-tera";
      flake = false;
    };
    neo-tree = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
      flake = false;
    };
  };
  outputs =
    {
      nixvim,
      flake-parts,
      pre-commit-hooks,
      neorg-overlay,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          system,
          self',
          ...
        }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [ neorg-overlay.overlays.default ];
          };
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = {
              imports = [ ./config ];
              package = inputs.neovim-nightly-overlay.packages.${system}.default;
            };
            extraSpecialArgs = {
              inherit inputs;
              inherit self';
            };
          };
        in
        {

          checks = {
            default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "A Nix Neovim Flake...";
            };
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = builtins.path {
                path = ./.;
                name = "source";
              };
              hooks = {
                statix.enable = true;
                nixfmt.enable = true;
              };
            };
          };

          formatter = pkgs.nixfmt;

          packages = {
            default = nvim;
            neorg-interim-ls = pkgs.callPackage ./pkgs/neorg-interim-ls.nix { inherit inputs; };
            btw = pkgs.callPackage ./pkgs/btw.nix { inherit inputs; };
            gitlinker = pkgs.callPackage ./pkgs/gitlinker.nix { inherit inputs; };
            precognition = pkgs.callPackage ./pkgs/precognition.nix { inherit inputs; };
            claudecode = pkgs.callPackage ./pkgs/claudecode.nix { inherit inputs; };
            tree-sitter-tera = pkgs.callPackage ./pkgs/tree-sitter-tera.nix { inherit inputs; };
            neo-tree = pkgs.callPackage ./pkgs/neo-tree.nix { inherit inputs; };
          };

          devShells = {
            default = with pkgs; mkShell { inherit (self'.checks.pre-commit-check) shellHook; };
          };
        };
    };
}
