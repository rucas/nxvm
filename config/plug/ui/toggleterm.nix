{
  plugins.toggleterm = {
    enable = true;
    settings = {
      shade_terminals = false;
      open_mapping = "[[<C-\\>]]";
      on_open = ''
        function(_)
          local name = vim.fn.bufname("neo-tree")
          local winnr = vim.fn.bufwinnr(name)

          if winnr == 1 then
            vim.defer_fn(function()
              local cmd = string.format("Neotree toggle")
              vim.cmd(cmd)
              vim.cmd(cmd)
              vim.cmd("wincmd p")
            end, 100)
          end
        end
      '';
    };
  };
}
