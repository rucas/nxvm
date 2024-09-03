{ pkgs, inputs, ... }: {
  extraPlugins = with pkgs.vimUtils;
    [
      (buildVimPlugin {
        name = "btw.nvim";
        src = inputs.btw;
      })
    ];

  extraConfigLua = ''
    require('btw').setup({
      text = [[／l、
          （ﾟ､ ｡ ７
    l  ~ヽ
         じしf_,)ノ]],
    })
  '';
}
