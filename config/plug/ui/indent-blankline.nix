{
  plugins.indent-blankline = { enable = true; };
  extraConfigLua = ''
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)

    require("ibl").setup({
      exclude = {
        filetypes = {
          "markdown",
          "terminal",
        },
        buftypes = {
          "terminal"
        },
      },
      scope = {
        show_start = false,
        show_end = false,
        show_exact_scope = true,
      },
    });
  '';
}
