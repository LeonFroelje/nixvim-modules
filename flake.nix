{
  description = "Modular NixVim Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;

      # Helper to build the Neovim package easily in other flakes
      mkNvim =
        modules:
        nixvim.legacyPackages.${system}.makeNixvim {
          imports = [ ./common.nix ] ++ modules;
        };

      # Define our language modules and their internal config keys
      languages = {
        python = ./python.nix;
        rust = ./rust.nix;
        tofu = ./tofu.nix;
        bash = ./bash.nix;
        javascript = ./javascript.nix;
        svelte = ./svelte.nix;
        latex = ./latex.nix;
        typst = ./typst.nix;
        json = ./json.nix;
      };
    in
    {
      # Standard modules for manual importing
      nixosModules =
        (lib.mapAttrs (name: path: {
          imports = [ path ];
          "${name}Config".enable = true;
        }) languages)
        // {
          # Manual overrides for language-specific variants
          latex-en-US = {
            imports = [ ./latex.nix ];
            latexConfig = {
              enable = true;
              language = "en-US";
            };
          };
          all = import ./all.nix;
          common = import ./common.nix;
          codecompanion = import ./codecompanion.nix;
        };

      # The helper function exported for your devShells
      lib.mkNvim = mkNvim;
    };
}
