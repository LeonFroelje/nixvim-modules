{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.typstConfig;
in
{
  options.typstConfig = with lib; {
    enable = mkEnableOption "typst config";
  };
  config = lib.mkIf cfg.enable {
    extraConfigLua = "
      require('typst-preview').setup({ dependencies_bin = {['tinymist'] = \"${pkgs.tinymist}/bin/tinymist\" }})
    ";
    plugins = {
      typst-preview = {
        enable = true;
        settings = {
        };
      };

      treesitter = {
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          typst
        ];
      };
      lsp = {
        servers = {
          tinymist = {
            enable = true;
          };
        };
      };
      conform-nvim.settings.formatters_by_ft.typst = [ "typstyle" ];
    };
  };
}
