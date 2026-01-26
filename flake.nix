{
  description = "Elysia on NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, fenix }: let
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    fenixLib = fenix.packages."x86_64-linux";
    skiaBinaries = pkgs.fetchurl {
      url = "https://github.com/rust-skia/skia-binaries/releases/download/0.87.0/skia-binaries-e551f334ad5cbdf43abf-x86_64-unknown-linux-gnu-egl-gl-pdf-svg-textlayout-wayland-x11.tar.gz";
      sha256 = "1644cvqr5crb2ighh1fzfprfb55spq3lmzh578vygdz5ckp5p9lv";
    };

  in {
    packages.x86_64-linux.default = pkgs.callPackage ./modules/wrapElysia.nix { inherit fenixLib; inherit skiaBinaries; };
  };
}
