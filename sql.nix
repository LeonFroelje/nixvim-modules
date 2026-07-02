{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.sqlConfig;
in
{
  options.sqlConfig.enable = lib.mkEnableOption "sql support";
  config = lib.mkIf cfg.enable {
    plugins.treesitter.grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.sql ];
    plugins.lsp.servers.sqls = {
      enable = true;
    };
    # plugins.conform-nvim.settings.formatters_by_ft.rust = [ "rustfmt" ];
  };
}
