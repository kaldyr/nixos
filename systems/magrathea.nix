{ inputs, pkgs, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        ../disko/magrathea.nix
        ../services/forgejo.nix
        ../services/nextcloud.nix
        ../services/pipewire.nix
        ../programs/kodi.nix
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
            options = [ "defaults" "size=2G" "mode=755" ];
        };

        "/etc/ssh".neededForBoot = true;

        "/home" = {
            device = "none";
            fsType = "tmpfs";
            neededForBoot = true;
            options = [ "defaults" "size=256M" "mode=755" ];
        };

        "/nix".neededForBoot = true;
        "/state".neededForBoot = true;

        # To manually create the raid array:
        #    mkfs.btrfs -m raid10 -d raid10 /dev/sdW /dev/sdX /dev/sdY /dev/sdZ
        #    mkdir -p /storage
        #    mount /dev/sdW /storage
        #    cd /storage
        #    btrfs subvolume create @media
        #    btrfs subvolume create @snaps
        #    cd ..
        #    umount /storage

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

    services.tailscale.useRoutingFeatures = "server";

    services.samba = {

        enable = true;

        settings = /* bash */ ''
            netbios name = magrathea
            mdns name = mdns
            server string = magrathea media share
            min protocol = SMB3
            encrypt passwords = true
            wins support = yes
            local master = yes
            preferred master = yes
            workgroup = WORKGROUP
        '';

        shares.media = {
            path = "/storage/media";
            browsable = "yes";
            public = "yes";
            writeable = "yes";
            "force user" = "matt";
            "force group" = "users";
            "create mask" = "0644";
            "directory mask" = "0755";
        };

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

}
