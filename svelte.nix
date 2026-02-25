{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.tofuConfig;
in
{
  options.tofuConfig.enable = lib.mkEnableOption "OpenTofu support";
  config = lib.mkIf cfg.enable {
    plugins.treesitter.grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.terraform ];
    plugins.lsp.servers = {
      svelte.enable = true;
    };
    plugins.conform-nvim.settings.formatters_by_ft = {
      svelte = [ "prettier" ];
    };
  };
}
