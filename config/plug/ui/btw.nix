{ self', ... }:
{
  extraPlugins = [ self'.packages.btw ];

  extraConfigLua = ''
    require('btw').setup({
      text = [[／l、
          （ﾟ､ ｡ ７
    l  ~ヽ
         じしf_,)ノ]],
    })
  '';
}
