{
  lib,
  mkFranzDerivation,
  fetchurl,
  stdenv,
  libxshmfence,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "ferdium: arch ${system} not supported";

  arch =
    {
      x86_64-linux = "amd64";
      aarch64-linux = "arm64";
    }
    .${system} or throwSystem;

  hash =
    {
      x86_64-linux = "sha256-ODQKFjBa2riJY26aPaAfLzuCyLYkB5oYSxIE28nMmwY=";
      aarch64-linux = "sha256-CYHoTw6JUyU63iTd9tAbfWVnb48WcZgGtjthqnlAD8I=";
    }
    .${system} or throwSystem;
in
mkFranzDerivation rec {
  pname = "ferdium";
  name = "Ferdium";
  version = "7.1.2";
  src = fetchurl {
    url = "https://github.com/ferdium/ferdium-app/releases/download/v${version}/Ferdium-linux-${version}-${arch}.deb";
    inherit hash;
  };

  extraBuildInputs = [ libxshmfence ];

  meta = {
    description = "All your services in one place built by the community";
    homepage = "https://ferdium.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ magnouvean ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    hydraPlatforms = [ ];
  };
}
