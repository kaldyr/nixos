{
  lib,
  pkgs,
  ...
}:
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;

    downloadDirPermissions = "2775";
    group = "media";
    home = "/state/transmission";
    openPeerPorts = true;

    settings = {
      download-dir = "/storage/media/Downloads";
      incomplete-dir = "/storage/media/Downloads/Incomplete";
      incomplete-dir-enabled = true;
      rpc-host-whitelist = "downloads.brill-godzilla.ts.net";
      umask = 7;
    };

    webHome = pkgs.fetchFromGitHub {
      owner = "killemov";
      repo = "Shift";
      rev = "cc70dabaab4b20bd938bb08a9ddb2fcdce07f42b";
      hash = "sha256-vct2wrtpMir6SxsnMr6ICvjkdi9oMOYeSRAUVrrT4a4=";
    };
  };

  systemd =
    let
      requiredMounts = [ "state.mount" "storage-media.mount" ];
    in
    {
      tmpfiles.rules = [ "d /state/transmission 0770 transmission media -" ];

      services = {
        transmission = {
          after = requiredMounts;
          requires = [ "transmission-setup.service" ] ++ requiredMounts;
          serviceConfig.StateDirectory = lib.mkForce [ ];
        };

        transmission-setup = {
          after = requiredMounts;
          requires = requiredMounts;
        };
      };
    };
}
