{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.leanConfig;
in
{
  options.leanConfig.enable = lib.mkEnableOption "Lean 4 support";

  config = lib.mkIf cfg.enable {
    plugins.lean = {
      enable = true;
      settings.lsp.enable = true;
    };

    # Let each project's lean-toolchain select its Lean version.
    dependencies.lean.package = pkgs.elan;
  };
}
