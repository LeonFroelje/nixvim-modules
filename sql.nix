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
  options.sqlConfig = {
    enable = lib.mkEnableOption "sql support";
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;

    };

  };

  config = lib.mkIf cfg.enable {
    plugins.treesitter.grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.sql ];
    plugins.lsp.servers.sqls = {
      enable = true;
      cmd = [
        "${pkgs.sqls}"
        "-config"
        "${cfg.configFile}"
      ];
    };
    # plugins.conform-nvim.settings.formatters_by_ft.rust = [ "rustfmt" ];
  };
}
