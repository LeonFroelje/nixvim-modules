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
    ./sql.nix
    ./ltex.nix
    ./codecompanion.nix
    ./json.nix
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
    };
    typstConfig = {
      enable = true;
    };
    ltexConfig = {
      enable = true;
      language = "de-DE";
      languagetoolServer = "http://localhost:8081";
    };
    sqlConfig.enable = true;
    codecompanionConfig = {
      enable = true;
    };
    jsonConfig.enable = true;

    # Add extra global tools that were in your original monolithic config
    # environment.systemPackages = with pkgs; [
    #   ripgrep
    #   fd
    #   nixfmt
    #   typstyle
    # ];
  };
}
