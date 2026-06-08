{
  description = "Ferdium - All your services in one place built by the community";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        ferdium = pkgs.callPackage ./nix/package.nix {
          mkFranzDerivation = pkgs.callPackage (pkgs.path + "/pkgs/applications/networking/instant-messengers/franz/generic.nix") { };
        };
      in
      {
        packages = {
          inherit ferdium;
          default = ferdium;
        };
      }
    ) // {
      overlays = {
        default = import ./nix/overlay.nix;
      };
    };
}
