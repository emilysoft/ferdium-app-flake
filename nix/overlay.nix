final: prev: {
  ferdium = final.callPackage ./package.nix {
    mkFranzDerivation = final.callPackage (final.path + "/pkgs/applications/networking/instant-messengers/franz/generic.nix") { };
  };
}
