{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.latexConfig;
in
{
  options.latexConfig = with lib; {
    enable = mkEnableOption "LaTeX support with NixVim";
    ltexPackage = mkOption {
      type = types.package;
      default = pkgs.ltex-ls-plus;
    };
    language = mkOption {
      type = types.enum [
        "de-DE"
        "en-US"
        "en-GB"
      ];
      default = "de-DE";
      description = "The language used by ltex-ls-plus for spell and grammar checking.";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins = {
      treesitter = {
        grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.latex ];
      };

      lsp = {
        servers = {
          # Main LaTeX LSP for compilation and symbols
          texlab.enable = true;

          # Grammar and Spell-checking
          ltex_plus = {
            enable = true;
            package = cfg.ltexPackage;
            cmd = [ "ltex-ls-plus" ];
            settings = {
              ltex.language = cfg.language;
            };
          };
        };
      };
    };
  };
}
