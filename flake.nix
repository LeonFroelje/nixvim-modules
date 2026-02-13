{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
    nixosModules = {
      typst-de-DE = { config, lib, pkgs, ... }: {
        imports = [ ./typst.nix ./common.nix ];
        typstConfig = {
          enable = true;
          language = "de-DE";
        };
      };
      typst-en-US = { config, lib, pkgs, ... }: {
        imports = [ ./typst.nix ./common.nix ];
        typstConfig = {
          enable = true;
          language = "en-US";
        };
      };
      typst-en-GB = { config, lib, pkgs, ... }: {
        imports = [ ./typst.nix ./common.nix ];
        typstConfig = {
          enable = true;
          language = "en-GB";
        };
      };
      python = {
        imports = [ ./common.nix ./python.nix ];
        pythonConfig.enable = true;
      };
    };
  };
}
