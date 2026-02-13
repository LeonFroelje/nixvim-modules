{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.bashConfig;
in
{
  options.bashConfig.enable = lib.mkEnableOption "Bash support";
  config = lib.mkIf cfg.enable {
    plugins = {
      treesitter.grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.bash ];
      lsp.servers.bashls.enable = true;
      conform-nvim.settings.formatters_by_ft.sh = [ "beautysh" ];
    };
  };
}
