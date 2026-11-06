{
  pkgs,
  ...
}:
{
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;

    downloadDirPermissions = "2775";
    home = "/state/transmission";
    group = "media";

    settings = {
      download-dir = "/storage/media/Downloads";
      incomplete-dir = "/storage/media/Downloads/Incomplete";
      incomplete-dir-enabled = true;
      rpc-host-whitelist = "downloads.brill-godzilla.ts.net";
      umask = 7;
    };

    openPeerPorts = true;
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
        };

        transmission-setup = {
          after = requiredMounts;
          requires = requiredMounts;
        };
      };
    };
}
