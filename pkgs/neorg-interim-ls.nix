{
  inputs,
  vimUtils,
  pkgs,
}:
vimUtils.buildVimPlugin {
  pname = "neorg-interim-ls";
  src = inputs.neorg-interim-ls;
  version = inputs.neorg-interim-ls.shortRev;

  doCheck = false;

  buildInputs = with pkgs.vimPlugins; [
    neorg
  ];
}
