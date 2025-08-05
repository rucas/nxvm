{ config, ... }:
let
  colors = import ../colors/${config.theme}.nix;
  lua = x: { __raw = x; };
in
{
  colorschemes.gruvbox = {
    enable = true;
    settings = {
      palette_overrides = {
        light1 = "#d4be98";
        aqua = "#8bba7f";
        bright_red = "#ea6962";
        neutral_red = "#b85651";
        bright_green = "#a9b665";
        faded_green = "#545b32";
        bright_orange = "#e78a4e";
        bright_yellow = "#d8a657";
        blue = "#7daea3";
        faded_blue = "#3e5751";
      };
      inverse = false;
      terminal_colors = true;
      overrides = {

        NormalFloat = {
          fg = colors.base04;
          bg = colors.background;
        };

        # NOTE:
        # https://github.com/nvim-telescope/telescope.nvim/blob/master/plugin/telescope.lua
        TelescopeNormal = {
          fg = colors.base05;
          bg = colors.background;
        };
        TelescopeResultsNormal = {
          fg = colors.base05;
          bg = colors.base00;
        };
        TelescopeResultsBorder = {
          fg = colors.base00;
          bg = colors.base00;
        };
        TelescopeResultsTitle = {
          fg = colors.base00;
          bg = colors.base00;
        };
        TelescopePreviewNormal = {
          fg = colors.base01;
          bg = colors.base01;
        };
        TelescopePreviewBorder = {
          fg = colors.base01;
          bg = colors.base01;
        };
        TelescopePreviewTitle = {
          fg = colors.base01;
          bg = colors.base01;
        };
        TelescopeBorder = {
          fg = colors.background;
          bg = colors.background;
        };
        # -- Telescope Prompt: this is where you type in Telescope
        TelescopePromptNormal = {
          fg = colors.base05;
          bg = colors.base02;
        };
        TelescopePromptBorder = {
          fg = colors.base02;
          bg = colors.base02;
        };
        TelescopePromptTitle = {
          fg = colors.base02;
          bg = colors.base02;
        };
        TelescopePromptCounter = {
          fg = colors.base03;
          bg = colors.base02;
        };
        TelescopeSelection = {
          bg = colors.faded_blue;
          bold = true;
        };
        TelescopeMatching = {
          fg = colors.base08;
        };

        # more subtle line numbers
        LineNr = {
          fg = colors.base02;
        };
        SignColumn = {
          fg = colors.base03;
          bg = colors.background;
        };

        WhichKeyBorder = {
          fg = colors.base05;
          bg = colors.background;
        };

        WhichKeyNormal = {
          fg = colors.base05;
          bg = colors.background;
        };

        # NOTE: no background for cleaner icons in status column
        DiagnosticSignInfo = {
          bg = "NONE";
          fg = colors.base0D;
        };
        DiagnosticSignHint = {
          bg = "NONE";
          fg = colors.base0A;
        };
        DiagnosticSignWarn = {
          bg = "NONE";
          fg = colors.base09;
        };
        DiagnosticSignError = {
          bg = "NONE";
          fg = colors.base08;
        };
        Folded = {
          bg = colors.base01;
          fg = colors.base08;
        };

        NeoTreeTitleBar = {
          bg = colors.base05;
        };
        NeoTreeFilterTerm = {
          fg = colors.base08;
        };
        NeoTreeNormal = {
          bg = colors.base01;
        };
        NeoTreeNormalNC = {
          bg = colors.base01;
        };
        NeoTreeWinSeparator = {
          bg = "NONE";
          fg = colors.base01;
        };

        WinSeparator = {
          bg = "NONE";
          fg = colors.base01;
        };

        # Neorg heading highlights matching Gruvbox theme
        "@neorg.headings.1.title" = {
          fg = colors.base08; # bright red
          bold = true;
        };
        "@neorg.headings.2.title" = {
          fg = colors.base09; # bright orange
          bold = true;
        };
        "@neorg.headings.3.title" = {
          fg = colors.base0A; # bright yellow
          bold = true;
        };
        "@neorg.headings.4.title" = {
          fg = colors.base0B; # bright green
          bold = true;
        };
        "@neorg.headings.5.title" = {
          fg = colors.base0D; # bright blue
          bold = true;
        };
        "@neorg.headings.6.title" = {
          fg = colors.base0E; # bright purple
          bold = true;
        };
        
        # Neorg heading prefix icons
        "@neorg.headings.1.prefix" = {
          fg = colors.base08; # bright red
        };
        "@neorg.headings.2.prefix" = {
          fg = colors.base09; # bright orange  
        };
        "@neorg.headings.3.prefix" = {
          fg = colors.base0A; # bright yellow
        };
        "@neorg.headings.4.prefix" = {
          fg = colors.base0B; # bright green
        };
        "@neorg.headings.5.prefix" = {
          fg = colors.base0D; # bright blue
        };
        "@neorg.headings.6.prefix" = {
          fg = colors.base0E; # bright purple
        };
      };
    };
  };
}
