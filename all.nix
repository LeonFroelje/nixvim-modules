{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./common.nix
    ./python.nix
    ./rust.nix
    ./tofu.nix
    ./latex.nix
    ./typst.nix
    ./javascript.nix
    ./bash.nix
  ];

  config = {
    # Enable every language-specific configuration
    pythonConfig.enable = true;
    rustConfig.enable = true;
    tofuConfig.enable = true;
    bashConfig.enable = true;
    javascriptConfig.enable = true;

    # Enable document formats with a default language
    latexConfig = {
      enable = true;
      language = "de-DE";
    };
    typstConfig = {
      enable = true;
      language = "de-DE";
    };

    # Add extra global tools that were in your original monolithic config
    # environment.systemPackages = with pkgs; [
    #   ripgrep
    #   fd
    #   nixfmt
    #   typstyle
    # ];
  };
}
