{ self', ... }:
{
  extraPlugins = [ self'.packages.precognition ];
  extraConfigLua = ''
    require('precognition').setup({
      highlightColor = { link = "SignColumn" },
      startVisible = false,
    })
  '';
}
