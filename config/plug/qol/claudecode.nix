{ self', ... }:
{
  extraPlugins = [ self'.packages.claudecode ];

  extraConfigLua = ''
    -- Only setup claudecode in interactive environments
    if vim.fn.has('nvim') == 1 and os.getenv('NIX_BUILD_TOP') == nil then
      pcall(function()
        local setup_opts = {}
        require('claudecode').setup(setup_opts)
      end)
    end
  '';
}
