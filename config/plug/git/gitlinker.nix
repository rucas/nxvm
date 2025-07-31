{ pkgs, inputs, ... }:
{
  extraPlugins = [ (pkgs.callPackage ../../../pkgs/gitlinker.nix { inherit inputs; }) ];
  extraConfigLua = ''
    require('gitlinker').setup()
  '';
  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gl";
      action = "<cmd>GitLink<cr>";
      options = {
        desc = "Copy URL";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gL";
      action.__raw = ''
        function()
          require("gitlinker").link({ action = require("gitlinker.actions").system })
        end
      '';
      options = {
        desc = "Open URL";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gb";
      action.__raw = ''
        function()
          require("gitlinker").link({ router_type = "blame" })
        end
      '';
      options = {
        desc = "Copy Blame";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gB";
      action.__raw = ''
        function()
          require("gitlinker").link({
            router_type = "blame",
            action = require("gitlinker.actions").system,
          })
        end
      '';
      options = {
        desc = "Open Blame";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gd";
      action.__raw = ''
        function()
          require("gitlinker").link({ router_type = "default_branch" })
        end
      '';
      options = {
        desc = "Copy Default Branch";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gD";
      action.__raw = ''
        function()
          require("gitlinker").link({
            router_type = "default_branch",
            action = require("gitlinker.actions").system,
          })
        end
      '';
      options = {
        desc = "Open Default Branch";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gc";
      action.__raw = ''
        function()
          require("gitlinker").link({ router_type = "current_branch" })
        end
      '';
      options = {
        desc = "Copy Current Branch";
        silent = true;
        noremap = true;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>gC";
      action.__raw = ''
        function()
          require("gitlinker").link({
            router_type = "current_branch",
            action = require("gitlinker.actions").system,
          })
        end
      '';
      options = {
        desc = "Open Current Branch";
        silent = true;
        noremap = true;
      };
    }
  ];
}
