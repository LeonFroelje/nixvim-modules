{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.svelteConfig;
in
{
  options.svelteConfig = {
    enable = lib.mkEnableOption "svelte";
  };
  config = lib.mkIf cfg.enable {
    plugins.treesitter.grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.svelte ];
    plugins.lsp.servers = {
      svelte.enable = true;
    };
    plugins.conform-nvim.settings.formatters_by_ft = {
      svelte = [ "prettier" ];
    };
  };
}
