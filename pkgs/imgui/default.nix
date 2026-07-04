{
  stdenv,
  lib,
  applyPatches,
  callPackage,
  cmake,
  fetchFromGitHub,
  darwin,
  glfw,
  libGL,
  sdl3,
  vcpkg,
  vulkan-headers,
  vulkan-loader,
  freetype,

  # NOTE: Not coming from vcpkg
  IMGUI_LINK_GLVND ?
    !stdenv.hostPlatform.isWindows && (IMGUI_BUILD_OPENGL2_BINDING || IMGUI_BUILD_OPENGL3_BINDING),

  # The intent is to mirror vcpkg's flags[^1],
  # but we only actually support Linux and glfw3 until someone contributes the rest
  # [^1]: https://github.com/microsoft/vcpkg/blob/095ee06e7f60dceef7d713e3f8b1c2eb10d650d7/ports/imgui/CMakeLists.txt#L33-L108
  IMGUI_BUILD_ALLEGRO5_BINDING ? false,
  IMGUI_BUILD_ANDROID_BINDING ? stdenv.hostPlatform.isAndroid,
  IMGUI_BUILD_DX9_BINDING ? false,
  IMGUI_BUILD_DX10_BINDING ? false,
  IMGUI_BUILD_DX11_BINDING ? false,
  IMGUI_BUILD_DX12_BINDING ? false,
  IMGUI_BUILD_GLFW_BINDING ? true,
  IMGUI_BUILD_GLUT_BINDING ? false,
  IMGUI_BUILD_METAL_BINDING ? stdenv.hostPlatform.isDarwin,
  IMGUI_BUILD_OPENGL2_BINDING ? false,
  IMGUI_BUILD_OPENGL3_BINDING ?
    IMGUI_BUILD_SDL3_BINDING || IMGUI_BUILD_GLFW_BINDING || IMGUI_BUILD_GLUT_BINDING,
  IMGUI_BUILD_OSX_BINDING ? stdenv.hostPlatform.isDarwin,
  IMGUI_BUILD_SDL3_BINDING ? true,
  IMGUI_BUILD_SDL3_RENDERER_BINDING ? IMGUI_BUILD_SDL3_BINDING,
  IMGUI_BUILD_SDLGPU3_BINDING ? false,
  IMGUI_TEST_ENGINE ? false,
  IMGUI_BUILD_VULKAN_BINDING ? false,
  IMGUI_BUILD_WIN32_BINDING ? false,
  IMGUI_FREETYPE ? true,
  IMGUI_FREETYPE_SVG ? false,
  # Enable docking and multi-viewports features[^2]
  # [^2]: https://github.com/ocornut/imgui/wiki/Docking
  dockingSupport ? false,
}:

let
  version = "1.91.9b";
  srcs = {
    master = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v${version}";
      hash = "sha256-dkukDP0HD8CHC2ds0kmqy7KiGIh4148hMCyA1QF3IMo=";
    };
    docking = fetchFromGitHub {
      owner = "ocornut";
      repo = "imgui";
      tag = "v${version}-docking";
      hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
    };
  };
  vcpkgSource = applyPatches {
    inherit (vcpkg) src;
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "imgui";
  inherit version;
  outputs = [
    "out"
  ];

  src = if dockingSupport then srcs.docking else srcs.master;

  cmakeRules = "${vcpkgSource}/ports/imgui";
  postPatch = ''
    cp "$cmakeRules"/{CMakeLists.txt,*.cmake.in} ./
    rm -f ./CMakeLists.txt
    cp ${./patches/CMakeLists.txt} ./CMakeLists.txt
    sed -i 's/find_dependency(freetype CONFIG)/find_dependency(Freetype)/g' ./imgui-config.cmake.in
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.ApplicationServices
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.GameController
  ];

  propagatedBuildInputs =
    lib.optionals IMGUI_LINK_GLVND [ libGL ]
    ++ lib.optionals IMGUI_BUILD_GLFW_BINDING [ glfw ]
    ++ lib.optionals IMGUI_BUILD_SDL3_BINDING [ sdl3 ]
    ++ lib.optionals IMGUI_BUILD_VULKAN_BINDING [
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optionals IMGUI_BUILD_METAL_BINDING [ darwin.apple_sdk.frameworks.Metal ]
    ++ lib.optionals IMGUI_FREETYPE [
      freetype
    ];

  cmakeFlags = [
    (lib.cmakeBool "IMGUI_BUILD_GLFW_BINDING" IMGUI_BUILD_GLFW_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_ALLEGRO5_BINDING" IMGUI_BUILD_ALLEGRO5_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_ANDROID_BINDING" IMGUI_BUILD_ANDROID_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX9_BINDING" IMGUI_BUILD_DX9_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX10_BINDING" IMGUI_BUILD_DX10_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX11_BINDING" IMGUI_BUILD_DX11_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_DX12_BINDING" IMGUI_BUILD_DX12_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_GLFW_BINDING" IMGUI_BUILD_GLFW_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_GLUT_BINDING" IMGUI_BUILD_GLUT_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_METAL_BINDING" IMGUI_BUILD_METAL_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_OPENGL2_BINDING" IMGUI_BUILD_OPENGL2_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_OPENGL3_BINDING" IMGUI_BUILD_OPENGL3_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_OSX_BINDING" IMGUI_BUILD_OSX_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_SDL3_BINDING" IMGUI_BUILD_SDL3_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_SDL3_RENDERER_BINDING" IMGUI_BUILD_SDL3_RENDERER_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_SDLGPU3_BINDING" IMGUI_BUILD_SDLGPU3_BINDING)
    (lib.cmakeBool "IMGUI_TEST_ENGINE" IMGUI_TEST_ENGINE)
    (lib.cmakeBool "IMGUI_BUILD_VULKAN_BINDING" IMGUI_BUILD_VULKAN_BINDING)
    (lib.cmakeBool "IMGUI_BUILD_WIN32_BINDING" IMGUI_BUILD_WIN32_BINDING)
    (lib.cmakeBool "IMGUI_FREETYPE" IMGUI_FREETYPE)
    (lib.cmakeBool "IMGUI_FREETYPE_SVG" IMGUI_FREETYPE_SVG)
  ];

  passthru = {
    tests = {
      demo = callPackage ./demo { };
    };
  };

  meta = {
    description = "Bloat-free Graphical User interface for C++ with minimal dependencies";
    homepage = "https://github.com/ocornut/imgui";
    license = lib.licenses.mit; # vcpkg licensed as MIT too
    maintainers = with lib.maintainers; [
      SomeoneSerge
      ivyfanchiang
    ];
    platforms = lib.platforms.all;
  };
})
