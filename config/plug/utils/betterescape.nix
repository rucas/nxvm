{
  plugins.better-escape = { enable = true; };
  extraConfigLua = ''
    require("better_escape").setup({
      timeout = 2000,
      default_mappings = false,
      mappings = {
        i = {
          j = {
            k = "<Esc>",
          },
        },
        c = {
          j = {
            k = "<Esc>",
          },
        },
        v = {
          j = {
            k = "<Esc>",
          },
        },
        s = {
          j = {
            k = "<Esc>",
          },
        },
      },
    })
  '';
}
