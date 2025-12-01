{ self', ... }:
{
  extraPlugins = [ self'.packages.claudecode ];

  extraConfigLua = ''
    -- Only setup claudecode in interactive environments
    if vim.fn.has('nvim') == 1 and os.getenv('NIX_BUILD_TOP') == nil then
      pcall(function()
        local mcp_config_path = vim.fn.expand('~/.claude/.mcp.json')
        local setup_opts = {}

        if vim.fn.filereadable(mcp_config_path) == 1 then
          setup_opts.terminal_cmd = 'claude --mcp-config ~/.claude/.mcp.json'
        end

        require('claudecode').setup(setup_opts)
      end)
    end
  '';
}
