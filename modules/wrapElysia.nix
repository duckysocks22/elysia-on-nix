{ fenixLib, skiaBinaries, buildFHSEnv, alsa-lib, git, gnutls, mangohud, nss_latest, p7zip, xdelta, unzip, libwebp, imagemagick, python3, glibc, llvmPackages_latest, libX11, libXcursor, libXrandr, udev, libunwind, callPackage, lib, graphicsmagick }:


let
  elysia = callPackage ./elysia.nix { inherit fenixLib; inherit skiaBinaries; };
in

(buildFHSEnv {
  name = "elysia";
  targetPkgs = pkgs: ([
    elysia
    udev
    alsa-lib
    git
    gnutls
    mangohud
    nss_latest
    p7zip
    xdelta
    unzip
    libwebp
    imagemagick
    python3
    glibc
    llvmPackages_latest.libclang
    llvmPackages_latest.clang
    libX11
    libXcursor
    libXrandr
  ]);
  multiPkgs = pkgs: ([
    udev
    alsa-lib
    libunwind
  ]);
  runScript = "elysia";
  extraInstallCommands = let
    icon = "${elysia.src}/assets/elysia.png";
    in ''
    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      ${lib.getExe graphicsmagick} convert -resize "$size"x"$size" ${icon} $out/share/icons/hicolor/"$size"x"$size"/apps/elysia.png
    done
  mkdir -p $out/share/applications
  cat << EOF > $out/share/applications/elysia.desktop
[Desktop Entry]
Name=Elysia
Comment=Universal anime game launcher
Exec=${elysia}/bin/elysia
Icon=elysia
Terminal=false
Type=Application
Categories=Game;Utility;
Keywords=game;launcher;hoyo;genshin;honkai;endfield;
StartupNotify=true
StartupWMClass=elysia
EOF
'';
})
