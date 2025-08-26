{ inputs, vimUtils }:
vimUtils.buildVimPlugin {
  pname = "gitlinker.nvim";
  src = inputs.gitlinker;
  version = inputs.gitlinker.shortRev;
  nvimSkipModules = [ "spec_init" ];
}
