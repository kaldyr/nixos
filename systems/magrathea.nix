{ inputs, pkgs, ... }: {

    imports = [
        # inputs.nixos-hardware.nixosModules.common-cpu-intel
        ../disko/magrathea.nix
        ../services/forgejo.nix
        ../services/nextcloud.nix
        # ../services/pipewire.nix
        # ../programs/kodi.nix
    ];

    boot = {
        extraModulePackages = with pkgs; [ btrfs-progs ];
        initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
        initrd.kernelModules = [ "i915" ];
        kernelModules = [ "kvm-intel" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" ];
        loader.grub.gfxmodeEfi = "1920x1080";
    };

    environment.persistence."/state/system".directories = [ {
        directory = "/var/lib/certs";
        user = "root";
        group = "webservice";
        mode = "0750";
    } ];

    fileSystems = {

        "/" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=6G" "mode=755" ];
        };

        "/etc/ssh".neededForBoot = true;
        "/nix".neededForBoot = true;
        "/state".neededForBoot = true;

        "/storage/media" = {
            device = "/dev/disk/by-uuid/c3cb725e-8cee-4690-a44d-114100497133";
            fsType = "btrfs";
            options = [ "subvol=@media" "noatime" "compress-force=zstd:8" ];
        };

        "/storage/snaps" = {
            device = "/dev/disk/by-uuid/c3cb725e-8cee-4690-a44d-114100497133";
            fsType = "btrfs";
            options = [ "subvol=@snaps" "noatime" "compress-force=zstd:8" ];
        };

    };

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "America/Los_Angeles";

    services = {

        samba = {

            enable = true;
            package = pkgs.samba;

            openFirewall = true;

            settings = {

                global = {
                    "encrypt passwords" = true;
                    "invalid users" = [ "root" ];
                    "guest account" = "nobody";
                    "map to guest" = "bad user";
                    "netbios name" = "magrathea";
                    "security" = "user";
                    "server string" = "magrathea";
                    "workgroup" = "WORKGROUP";
                };

                "media" = {
                    path = "/storage/media";
                    comment = "Media";
                    browsable = "yes";
                    public = "yes";
                    "read only" = "no";
                    "guest ok" = "yes";
                    "force user" = "matt";
                    "force group" = "users";
                    "create mask" = "0664";
                    "directory mask" = "0775";
                };

            };

        };

        samba-wsdd.enable = true;
        samba-wsdd.openFirewall = true;

        tailscale.useRoutingFeatures = "server";

    };

    systemd.services."tailscale-certs" = {

        description = "Automatic renewal of Tailscale certificates";

        after = [ "network-pre.target" "tailscale.service" ];
        wants = [ "network-pre.target" "tailscale.service" ];
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

        after = [ "network-pre.target" "tailscale.service" ];
        wants = [ "network-pre.target" "tailscale.service" ];
        wantedBy = [ "multi-user.target" ];

        timerConfig = {
            OnCalendar = "weekly";
            Persistent = "true";
            Unit = "tailscale-certs.service";
        };

    };

    # Group that can access tailscale certificates
    users.groups."webservice" = {};

    # Configure a user for being a remote build server
    nix.settings.trusted-users = [ "nixremote" ];
    users.groups."nixremote" = {};
    users.users."nixremote" = {

        description = "Nix Remote Builder";

        home = "/home/nixremote";
        homeMode = "400";
        group = "nixremote";
        isSystemUser = true;

        openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjTNnEmk0a4o+t9fteNSNL/N4C+xE2uhQ+QnQ+girtb root@oolong"
        ];

    };

}
