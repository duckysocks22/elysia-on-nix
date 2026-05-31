{ rustPlatform, rust, fenixLib, cargo, rustc, rustfmt, clippy, rust-analyzer, openssl, ffmpeg, llvmPackages_latest, freetype, fontconfig, libGL, libglvnd, wayland, wayland-protocols, libxkbcommon, libX11, libXcursor, libXrandr, libXi, pkg-config, python3, skia, glibc, makeWrapper , vulkan-validation-layers, vulkan-loader, skiaBinaries, lib, fetchgit, alsa-lib }:

  rustPlatform.buildRustPackage {
        name = "elysia";
	version = "0.2";
        src = fetchgit {
          url = "https://dawn.wine/elysia/elysia.git";
	  rev = "ed14268de40fa214f5b86e5de0fd5c4e2c58baf5";
	  hash = "sha256-S3LrJrm4FmSCE1xl0ElNI9q4WUgzx3zJDqBQbCOPAEs=";
	};

        rustc = fenixLib.stable.rustc;
        cargo = fenixLib.stable.cargo;

        CARGO_TARGET_DIR = "target";

	cargoHash = "sha256-dbiSRDA8Arm6/GlCXmiXdsQwpd0tZy53+ok2/JMINBc=";

        buildInputs = [ cargo rustc rustfmt clippy rust-analyzer openssl ffmpeg llvmPackages_latest.clang llvmPackages_latest.libclang freetype fontconfig libGL libglvnd wayland wayland-protocols libxkbcommon ffmpeg libX11 libXcursor libXrandr libXi alsa-lib ];
        nativeBuildInputs = [ pkg-config python3 skia ffmpeg glibc makeWrapper ];

        cargoBuildFlags = [ "--bin" "elysia" ];

        preBuild = ''
        export SKIA_BINARIES_URL=file://${skiaBinaries}
        '';

        postInstall = ''
	  wrapProgram $out/bin/elysia \
	    --set WAYLAND_DISPLAY "$WAYLAND_DISPLAY" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath ([
              wayland
              libxkbcommon
	      libGL
	      libglvnd
              vulkan-loader
              fontconfig
              freetype
	      libX11
	      libXcursor
	      libXrandr
	      libXi
	      ])}"
        '';


        env = {

          BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${glibc.dev}/include -I${llvmPackages_latest.libclang.lib}/lib/clang/${llvmPackages_latest.libclang.version}/include";

          LIBCLANG_PATH = "${llvmPackages_latest.libclang.lib}/lib";

          LD_LIBRARY_PATH = "${wayland}/lib:${libxkbcommon}/lib:${vulkan-loader}/lib:${vulkan-validation-layers}/lib";
          VK_LAYER_PATH = "${vulkan-validation-layers}/share/vulkan/explicit_layer.d";

	  FFMPEG_DIR = "${ffmpeg.dev}";

	  SKIA_SOURCE_BINARIES_URL = "file://${skiaBinaries}";

          RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";
        };

        dontUseNinjaInstall = true;
}
