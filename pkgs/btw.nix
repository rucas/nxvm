{ inputs, vimUtils }:
vimUtils.buildVimPlugin {
  pname = "btw.nvim";
  src = inputs.btw;
  version = inputs.btw.shortRev;
}

