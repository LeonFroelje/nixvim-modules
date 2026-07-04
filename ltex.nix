{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ltexConfig;
in
{
  options.ltexConfig = with lib; {
    enable = mkEnableOption "ltex config";
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
    };
    languagetoolServer = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "URL for the languagetool server";
    };
  };
  config = lib.mkIf cfg.enable {
    plugins = {
      lsp = {
        servers = {
          ltex_plus = {
            enable = true;
            package = cfg.ltexPackage;
            cmd = [ "ltex-ls-plus" ];
            settings = {
              ltex.language = cfg.language;
              ltex.languageToolHttpServerUri = cfg.languagetoolServer;
            };
            onAttach.function = ''
              require("ltex_extra").setup({
                load_langs = { "${cfg.language}" },
                init_check = true,
                path = ".ltex", 
              })
            '';
          };
        };
      };
      ltex-extra = {
        enable = true;
        settings = {
          loadLangs = [ cfg.language ];
        };
      };
    };
  };
}
