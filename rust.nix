{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.rustConfig;
in
{
  options.rustConfig.enable = lib.mkEnableOption "Rust support";
  config = lib.mkIf cfg.enable {
    plugins.treesitter.grammarPackages = [ pkgs.vimPlugins.nvim-treesitter.builtGrammars.rust ];
    plugins.lsp.servers.rust_analyzer = {
      enable = true;
      installRustc = false;
      installCargo = false;
    };
  };
}
