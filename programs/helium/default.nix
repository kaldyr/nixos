{
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (symlinkJoin {
      name = "helium-gtk";
      paths = [ helium ];
      nativeBuildInputs = [ makeWrapper ];

      postBuild = ''
        wrapProgram $out/bin/helium \
          --prefix LD_LIBRARY_PATH : "${ lib.makeLibraryPath [ gtk3 gtk4 ] }" \
          --add-flags "--disable-features=HeliumNoiseCanvas"
      '';
    })
  ];

  home-manager.users.${sysConfig.user}.xdg.mimeApps.associations.added = {
    "applications/md" = [ "helium.desktop" ];
    "text/html" = [ "helium.desktop" ];
    "x-scheme-handler/ftp" = [ "helium.desktop" ];
    "x-scheme-handler/http" = [ "helium.desktop" ];
    "x-scheme-handler/https" = [ "helium.desktop" ];
  };
}
