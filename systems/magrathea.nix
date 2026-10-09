{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    ../disko/magrathea.nix
    ../services/audiobookshelf
    ../services/forgejo
    ../services/kodi
    ../services/linkwarden
    ../services/navidrome
    ../services/nextcloud
    ../services/openstarbound
    ../services/radicale
    ../services/syncthing
    ../services/technitium
    ../services/vikunja
  ];

  boot = {
    initrd.availableKernelModules = [
      "xhci_pci"
      "ehci_pci"
      "ahci"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    initrd.kernelModules = [ "i915" ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "zswap.max_pool_percent=25" ];
    loader.grub.gfxmodeEfi = "1920x1080";
  };

  environment.systemPackages = with pkgs; [
    picard
    flac
  ];

  environment.persistence."/state/system".directories = [
    {
      directory = "/var/lib/certs";
      user = "root";
      group = "webservice";
      mode = "0750";
    }
  ];

  fileSystems =
    let
      hddDrive = "/dev/disk/by-uuid/c3cb725e-8cee-4690-a44d-114100497133";
      hddOptions = [ "defaults" "noatime" "compress=zstd:8" ];
      # ssdOptions = [ "defaults" "noatime" "compress=zstd:3" ];
    in
  {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };

    "/storage/media" = {
      device = hddDrive;
      fsType = "btrfs";
      options = [ "subvol=@media" ] ++ hddOptions;
    };

    "/storage/snaps" = {
      device = hddDrive;
      fsType = "btrfs";
      options = [ "subvol=@snaps" ] ++ hddOptions;
    };
  };

  hardware = {
    alsa.enable = true;

    graphics = {
      enable = true;
      extraPackages = with pkgs; [ intel-media-driver ];
    };

    enableRedistributableFirmware = true;
    enableAllFirmware = true;
  };

  services = {
    pipewire.enable = lib.mkForce false;
    pulseaudio.enable = lib.mkForce false;
    tailscale.useRoutingFeatures = "server";
  };

  systemd.services."tailscale-certs" = {
    description = "Automatic renewal of Tailscale certificates";

    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig.type = "oneshot";

    script = /* bash */ ''
      status="Starting";

      until [ $status = "Running" ]; do
          sleep 2
          status=$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)
      done

      ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file /var/lib/certs/magrathea.brill-godzilla.ts.net.crt \
          --key-file /var/lib/certs/magrathea.brill-godzilla.ts.net.key \
          magrathea.brill-godzilla.ts.net
      chown :webservice /var/lib/certs/magrathea.brill-godzilla.ts.net.{crt,key}
      chmod 0640 /var/lib/certs/magrathea.brill-godzilla.ts.net.{crt,key}
    '';
  };

  systemd.timers."tailscale-certs" = {
    description = "Automatic renewal of Tailscale certificates";

    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    timerConfig = {
      OnCalendar = "weekly";
      Persistent = "true";
      Unit = "tailscale-certs.service";
    };
  };

  users.groups."media" = { };
  users.groups."webservice" = { };
  users.users.matt.extraGroups = [ "media" ];
  time.timeZone = "America/Los_Angeles";
}

