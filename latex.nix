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
        };
      };
    };
  };
}
