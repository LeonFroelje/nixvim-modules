{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.appearance;
  dark = cfg.mode == "dark";
in
{
  options.appearance = {
    theme = lib.mkOption {
      type = lib.types.enum [
        "gruvbox"
        "catppuccin"
        "tokyonight"
        "everforest"
        "onedark"
        "material"
        "github"
      ];
      default = "material";
      description = "Neovim colorscheme family.";
    };

    mode = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
      ];
      default = "light";
      description = "Light or dark colorscheme variant.";
    };

    everforest.contrast = lib.mkOption {
      type = lib.types.enum [
        "soft"
        "medium"
        "hard"
      ];
      default = "medium";
      description = "Gruvbox contrast. Only applies when using Gruvbox.";
    };

    gruvbox.contrast = lib.mkOption {
      type = lib.types.enum [
        "soft"
        "medium"
        "hard"
      ];
      default = "soft";
      description = "Gruvbox contrast. Only applies when using Gruvbox.";
    };
  };

  config = lib.mkMerge [
    {
      opts.background = cfg.mode;
    }

    (lib.mkIf (cfg.theme == "gruvbox") {
      colorschemes.gruvbox = {
        enable = true;
        settings = {
          terminal_colors = true;
          undercurl = true;
          underline = true;
          bold = true;
          italic = {
            comments = true;
            strings = true;
            emphasis = true;
            operators = false;
            folds = true;
          };
          strikethrough = true;

          # Gruvbox represents its medium contrast with an empty string.
          contrast = if cfg.gruvbox.contrast == "medium" then "" else cfg.gruvbox.contrast;
        };
      };
    })

    (lib.mkIf (cfg.theme == "catppuccin") {
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = if dark then "mocha" else "latte";
          background = {
            light = "latte";
            dark = "mocha";
          };
        };
      };
    })

    (lib.mkIf (cfg.theme == "tokyonight") {
      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = if dark then "night" else "day";
          light_style = "day";
        };
      };
    })
    (lib.mkIf (cfg.theme == "everforest") {
      colorschemes.everforest = {
        enable = true;
        settings = {
          background = cfg.everforest.contrast;
          transparent_background = 0;
          enable_italic = 1;

        };
      };
    })
    (lib.mkIf (cfg.theme == "onedark") {
      colorschemes.onedark = {
        enable = true;
        settings = {
          style = if dark then "dark" else "light";
          transparent = false;
          colors = lib.optionalAttrs (!dark) {
            # fg = "#24262d";
            black = "#000000";
            grey = "#626670";
            green = "#35a03a";
            blue = "#2455b5";
          };
        };
      };
    })
    (lib.mkIf (cfg.theme == "material") {
      extraPlugins = [ pkgs.vimPlugins.material-nvim ];
      opts.termguicolors = true;
      extraConfigLuaPre = ''
        vim.g.material_style = "${if dark then "darker" else "lighter"}"
        require("material").setup({
          high_visibility = { lighter = true },        
        })
      '';
      colorscheme = "material";
    })
    (lib.mkIf (cfg.theme == "github") {
      colorschemes.github-theme = {
        enable = true;
        settings.options.transparent = false;
        colorscheme = if dark then "github_dark_default" else "github_light_default";
      };
    })
  ];
}
