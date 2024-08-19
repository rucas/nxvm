{
  description = "A Nix Neovim Flake...";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        devshell.follows = "";
        flake-compat.follows = "";
        git-hooks.follows = "";
        # NOTE: will I need this later?
        home-manager.follows = "";
        nix-darwin.follows = "";
        treefmt-nix.follows = "";
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
  };
  outputs = { nixpkgs, nixvim, flake-parts, pre-commit-hooks, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { system, pkgs, self', lib, ... }:
        let
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = {
              imports = [ ./config ];
              package =
                inputs.neovim-nightly-overlay.packages.${system}.default;
            };
          };
        in {

          checks = {
            default = nixvim.lib.${system}.check.mkTestDerivationFromNvim {
              inherit nvim;
              name = "A Nix Neovim Flake...";
            };
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                statix.enable = true;
                nixfmt.enable = true;
              };
            };
          };

          formatter = pkgs.nixfmt;

          packages.default = nvim;

          devShells = {
            default = with pkgs;
              mkShell { inherit (self'.checks.pre-commit-check) shellHook; };
          };
        };
    };
}
