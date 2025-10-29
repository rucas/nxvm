{ config, ... }:
let
  colors = import ../colors/${config.theme}.nix;
in
{
  extraFiles = {
    "ftplugin/toggleterm.lua".text = ''
      vim.opt_local.spell = false
    '';
    "ftplugin/checkhealth.lua".text = ''
      vim.opt_local.spell = false
    '';
    "ftplugin/markdown.lua".text = ''
      vim.opt_local.textwidth = 120
    '';
    "ftplugin/norg.lua".text = '''';
  };
}
