{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.jsonConfig;
in
{
  options.jsonConfig = with lib; {
    enable = mkEnableOption "Neovim Json config";
  };
  config = lib.mkIf cfg.enable {
    plugins = {
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          json
        ];
      };
      lsp = {
        servers = {
          jsonls = {
            enable = true;
          };
        };
      };
      conform-nvim.settings.formatters_by_ft.json = [ "jsonls" ];
    };
  };
}
