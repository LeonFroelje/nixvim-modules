{pkgs, lib, config, ... }:
let cfg = config.pythonConfig;
in
{
  options.pythonConfig = with lib; { 
    enable = mkEnableOption "Neovim Python config";
    extraGrammars = mkOption {
      type = types.listOf derivation;
      default = [];
    };
  };
  config = lib.mkIf cfg.enable {
    plugins = {
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          python
          jinja
        ]; 
      };
      lsp = {
        servers = {
          jedi_language_server = {
            enable = true;
            onAttach.function = 
              "client.server_capabilities.documentFormattingProvider = false" 
              + 
              "\n"
              + 
              "client.server_capabilities.documentRangeFormattingProvider = false";
          };
          ruff = {
            enable = true;
          };
        };
      };
    };
  };
}
