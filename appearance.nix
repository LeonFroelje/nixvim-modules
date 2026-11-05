{ config, lib, ... }:
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
      ];
      default = "gruvbox";
      description = "Neovim colorscheme family.";
    };

    mode = lib.mkOption {
      type = lib.types.enum [
        "light"
        "dark"
      ];
      default = "dark";
      description = "Light or dark colorscheme variant.";
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
  ];
}
