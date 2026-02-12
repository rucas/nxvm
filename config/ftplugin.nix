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
    "ftplugin/norg.lua".text = ''
      require("hardtime").disable()
      vim.opt_local.textwidth = 120
      vim.opt_local.foldenable = true
      vim.schedule(function()
        vim.opt_local.foldlevel = 0
      end)
    '';
  };
}
