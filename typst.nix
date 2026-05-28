{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.typstConfig;
in
{
  options.typstConfig = with lib; {
    enable = mkEnableOption "typst config";
    language = mkOption {
      type = types.enum [
        "de-DE"
        "en-US"
        "en-GB"
      ];
      default = "de-DE";
    };
    languagetoolServer = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "URL for the languagetool server";
    };
  };
  config = lib.mkIf cfg.enable {
    extraConfigLua = "
      require('typst-preview').setup({ dependencies_bin = {['tinymist'] = \"${pkgs.tinymist}/bin/tinymist\" }})
    ";
    plugins = {
      typst-preview = {
        enable = true;
        settings = {
        };
      };

      treesitter = {
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          typst
        ];
      };
      lsp = {
        servers = {
          ltex_plus = {
            enable = true;
            # package = null;
            cmd = [ "ltex-ls-plus" ];
            settings = {
              ltex.language = cfg.language;
              ltex.languageToolHttpServerUri = cfg.languagetoolServer;
            };
            onAttach.function = ''
              require("ltex_extra").setup({
                load_langs = { "${cfg.language}" },
                init_check = true,
                -- Save dictionaries to ~/.local/share/nvim/ltex (Global)
                -- Alternatively, change this to ".ltex" to save a local dictionary per-project
                path = vim.fn.stdpath("data") .. "/ltex", 
              })
            '';
          };
          tinymist = {
            enable = true;
          };
        };
      };
      conform-nvim.settings.formatters_by_ft.typst = [ "typstyle" ];
      ltex-extra = {
        enable = true;
        settings = {
          loadLangs = [ cfg.language ];
        };
      };
      # };
    };
  };
}
