{ inputs, vimUtils }:
vimUtils.buildVimPlugin {
  pname = "claudecode.nvim";
  src = inputs.claudecode;
  version = inputs.claudecode.shortRev;
}
