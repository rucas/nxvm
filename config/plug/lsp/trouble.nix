{ lib, config, ... }:
{
  plugins.trouble = {
    enable = true;
  };
  keymaps = lib.mkIf config.plugins.trouble.enable [
    {
      mode = "n";
      key = "<leader>xQ";
      action = "<CMD>Trouble qflist toggle<CR>";
      options = {
        desc = "Trouble quifick toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>cs";
      action = "<CMD>Trouble symbols focus=false<CR>";
      options = {
        desc = "Trouble symbols toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>cl";
      action = "<CMD>Trouble lsp toggle focus=false win.position=right<CR>";
      options = {
        desc = "LSP Definitions / references / ... (Trouble)";
      };
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<CMD>Trouble diagnostics toggle<CR>";
      options = {
        desc = "Trouble diagnostics toggle";
      };
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<CMD>Trouble diagnostics toggle filter.buf=0<CR>";
      options = {
        desc = "Trouble diagnostics toggle (Buffer)";
      };
    }
    # ]x/[x rather than ]c/[c: the latter are Vim's diff-mode change motions,
    # which matter here because undotree opens a diff. Pairs with <leader>x.
    {
      mode = "n";
      key = "]x";
      action = "<cmd>lua require('trouble').next({ skip_groups = true, jump = true })<cr>";
      options = {
        desc = "Trouble next";
      };
    }
    {
      mode = "n";
      key = "[x";
      action = "<cmd>lua require('trouble').prev({ skip_groups = true, jump = true })<cr>";
      options = {
        desc = "Trouble prev";
      };
    }
  ];
}
