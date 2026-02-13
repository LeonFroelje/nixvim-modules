{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.javascriptConfig;
in
{
  options.javascriptConfig.enable = lib.mkEnableOption "JS/TS support";
  config = lib.mkIf cfg.enable {
    plugins = {
      treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        javascript
        typescript
        svelte
        html
        css
      ];
      lsp.servers = {
        ts_ls.enable = true;
        svelte.enable = true;
        cssls.enable = true;
        html.enable = true;
      };
      conform-nvim.settings.formatters_by_ft = {
        javascript = [ "prettier" ];
        typescript = [ "prettier" ];
      };
    };
  };
}
