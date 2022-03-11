{

  inputs = {
    naersk.url = "github:nmattia/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, naersk }:
  utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs { inherit system; };
    naersk-lib = pkgs.callPackage naersk {};
  in rec {

    # `nix build`
    packages.pw-volume = naersk-lib.buildPackage {
      pname = "pw-volume";
      root = ./.;
    };

    defaultPackage = packages.pw-volume;

    # `nix run`
    apps.pw-volume = utils.lib.mkApp {
      drv = packages.pw-volume;
    };

    defaultApp = apps.pw-volume;

    # `nix develop`
    devShell = with pkgs; mkShell {
      buildInputs = [ cargo rustc rustfmt pre-commit rustPackages.clippy ];
      RUST_SRC_PATH = rustPlatform.rustLibSrc;
    };

    nixosModule = { config }: { options = {}; config = {}; };

  });
}

