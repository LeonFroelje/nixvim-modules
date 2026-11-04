{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.typstConfig;
  tinymist = pkgs.tinymist.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "0.15.12";

      src = pkgs.fetchFromGitHub {
        owner = "Myriad-Dreamin";
        repo = "tinymist";
        tag = "v${finalAttrs.version}";
        hash = "sha256-fz83+npEyqjld+j75SrtIUM3Noq6pHOfrqBcCbtbf50=";
      };

      cargoHash = lib.fakeHash;
      cargoDeps = null;
    }
  );
in
{
  options.typstConfig = with lib; {
    enable = mkEnableOption "typst config";
  };
  config = lib.mkIf cfg.enable {
    extraConfigLua = "
      require('typst-preview').setup({ dependencies_bin = {['tinymist'] = \"${tinymist}/bin/tinymist\" }})
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
            package = tinymist;
          };
        };
      };
      conform-nvim.settings.formatters_by_ft.typst = [ "typstyle" ];
    };
  };
}
