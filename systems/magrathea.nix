{ inputs, pkgs, ... }: {

    imports = [
        inputs.nixos-hardware.nixosModules.common-cpu-intel
        ../disko/magrathea.nix
        ../programs/kodi.nix
        ../programs/nextcloud-server.nix
        ../programs/pipewire.nix
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

    hardware.enableRedistributableFirmware = true;
    hardware.enableAllFirmware = true;
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "America/Los_Angeles";

    services.tailscale.useRoutingFeatures = "server";

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

            ${pkgs.tailscale}/bin/tailscale cert magrathea.brill-godzilla.ts.net
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

}
