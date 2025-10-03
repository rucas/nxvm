{
  inputs,
  vimUtils,
  vimPlugins,
}:
vimUtils.buildVimPlugin {
  pname = "neo-tree.nvim";
  src = inputs.neo-tree;
  version = inputs.neo-tree.shortRev;
  dependencies = with vimPlugins; [
    plenary-nvim
    nui-nvim
  ];
  doCheck = false;
}
