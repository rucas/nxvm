{
  plugins.quicker = {
    enable = true;
    settings = {
      on_qf = {
        __raw = ''
          function(bufnr)
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
  };
}
