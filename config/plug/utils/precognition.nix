{ pkgs, inputs, ... }: {
  extraPlugins = with pkgs.vimUtils;
    [
      (buildVimPlugin {
        name = "precognition.nvim";
        src = inputs.precognition;
      })
    ];
  extraConfigLua = ''
    require('precognition').setup({
      highlightColor = { link = "SignColumn" },
      startVisible = false,
    })
  '';
}
