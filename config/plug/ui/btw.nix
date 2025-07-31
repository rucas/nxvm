{ pkgs, inputs, ... }:
{
  extraPlugins = [ (pkgs.callPackage ../../../pkgs/btw.nix { inherit inputs; }) ];

  extraConfigLua = ''
    require('btw').setup({
      text = [[／l、
          （ﾟ､ ｡ ７
    l  ~ヽ
         じしf_,)ノ]],
    })
  '';
}
