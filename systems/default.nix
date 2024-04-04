{ config, inputs, lib, sysConfig, ... }: {

    environment.defaultPackages = lib.mkForce [];

    networking = {
        enableIPv6 = false;
        firewall.checkReversePath = "loose";
        networkmanager.enable = true;
    };

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    nix = {

        gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 7d";
        };

        nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
        registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

        settings.experimental-features = "nix-command flakes";
        settings.auto-optimise-store = true;

    };

    programs.fuse.userAllowOther = true;
    programs.nano.enable = false;

    security.sudo = {
        execWheelOnly = true;
        extraConfig = ''
            Defaults lecture = never
        '';
    };

    services = {

        openssh = {
            enable = true;
            knownHosts = {
                "garm".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJId64RiXTZvY0oHr75V2TFURT6Qg8D6mgTCGVr59B7l root@gram";
                "hofud".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGYN+zwhYvBqGaKgxSPEVLj6KE2uGdbPUR1se1hN+1NG root@hofud";
                "magrathea".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKymXBmxO/Yb9lFRyW+w1O3mZ7I6iLgnxW0kgI/4e1O3 root@magrathea";
                "mjolnir".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEsWi8zGLMuMJM+2wawmRFEE6Qmnabq3kA4Rj3bLBBJ6 root@mjolnir";
            };
            settings = {
                KbdInteractiveAuthentication = false;
                PasswordAuthentication = false;
                PermitRootLogin = lib.mkForce "no";
            };
        };

        timesyncd.enable = true;

    };

    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.defaultSopsFile = ../secrets.yaml;

    system.stateVersion = sysConfig.instalVersion;

    systemd.extraConfig = ''
        DefaultTimeoutStopSec=10s
    '';

}
