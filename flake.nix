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
    checkmate = {
      url = "github:bngarren/checkmate.nvim";
      flake = false;
    };
  };
  outputs =
    {
      nixvim,
      flake-parts,
      pre-commit-hooks,
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
          pkgs,
          self',
          ...
        }:
        let
          nixvim' = nixvim.legacyPackages.${system};
          nvim = nixvim'.makeNixvimWithModule {
            inherit pkgs;
            module = {
              imports = [ ./config ];
              package = inputs.neovim-nightly-overlay.packages.${system}.default;
            };
            extraSpecialArgs = { inherit inputs; };
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
                nixfmt-rfc-style.enable = true;
              };
            };
          };

          formatter = pkgs.nixfmt-rfc-style;

          packages.default = nvim;

          devShells = {
            default = with pkgs; mkShell { inherit (self'.checks.pre-commit-check) shellHook; };
          };
        };
    };
}
