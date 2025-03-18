{ pkgs, inputs, ... }: {
  extraPlugins =
    [ (pkgs.callPackage ../../../pkgs/precognition.nix { inherit inputs; }) ];
  extraConfigLua = ''
    require('precognition').setup({
      highlightColor = { link = "SignColumn" },
      startVisible = false,
    })
  '';
}
