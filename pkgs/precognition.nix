{ inputs, vimUtils }:
vimUtils.buildVimPlugin {
  pname = "precognition.nvim";
  src = inputs.precognition;
  version = inputs.precognition.shortRev;
}
