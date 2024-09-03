{
  plugins = {
    lsp-format = { enable = true; };
    lsp = {
      enable = true;
      servers = {
        html = { enable = true; };
        lua-ls = { enable = true; };
        nil-ls = { enable = true; };
        marksman = { enable = true; };
        pyright = { enable = true; };
        tsserver = { enable = false; };
        yamlls = { enable = true; };
      };
    };
  };
}

