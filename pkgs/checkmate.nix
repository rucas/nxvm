{
  inputs,
  pkgs,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  buildInputs = [ pkgs.vimPlugins.luasnip ];
  pname = "checkmate.nvim";
  src = inputs.checkmate;
  version = inputs.checkmate.shortRev;
}
