{ config, inputs, lib, pkgs, sysConfig, ... }: {

    imports = [
        ../programs/btop.nix
        ../programs/direnv.nix
        ../programs/fish.nix
        ../programs/fzf.nix
        ../programs/git.nix
        ../programs/lazygit.nix
        ../programs/neovim.nix
        ../programs/numbat.nix
        ../programs/starship.nix
        ../programs/yazi.nix
        ../programs/zellij.nix
    ];

    boot.loader = {

        efi.efiSysMountPoint = "/boot";

        grub = {

            enable = true;

            device = "nodev";
            efiInstallAsRemovable = true;
            efiSupport = true;

            theme = pkgs.fetchFromGitHub {
                owner = "catppuccin";
                repo = "grub";
                rev = "0a37ab19f654e77129b409fed371891c01ffd0b9";
                sha256 = "sha256-jgM22pvCQvb0bjQQXoiqGMgScR9AgCK3OfDF5Ud+/mk=";
            } + "/src/catppuccin-frappe-grub-theme";

            useOSProber = false;

        };

    };

    environment = {

        defaultPackages = lib.mkForce [];

        # Home files that aren't declarative and need to be preserved
        persistence."/nix" = lib.mkIf sysConfig.homeImpermanence {
            hideMounts = true;
            users.${sysConfig.user}.directories = [
                { directory = ".config/sops/age"; mode = "0700"; }
                { directory = ".gnupg"; mode = "0700"; }
                { directory = ".local/share/keyrings"; mode = "0700"; }
                { directory = ".ssh"; mode = "0700"; }
            ];
        };

        # System files that aren't declarative and need to be preserved
        persistence."/nix/system" = lib.mkIf sysConfig.systemImpermanence {
            directories = [
                { directory = "/etc/NetworkManager/system-connections"; mode = "0700"; }
                { directory = "/var/lib/bluetooth"; mode = "0700"; }
                "/var/lib/nixos"
                "/var/lib/systemd/coredump"
                { directory = "/var/lib/tailscale"; mode = "0700"; }
                "/var/log"
            ];
            files = [ "/etc/machine-id" ];
        };

        systemPackages = with pkgs; [ tailscale ];

    };

    home-manager.users.${sysConfig.user}.home.packages = with pkgs; [
        age
        duf
        exiftool
        ffmpeg
        ffmpegthumbnailer
        g-ls
        gdu
        gnupg
        jq
        lazyjournal
        lazysql
        p7zip
        sops
        ssh-to-age
        unrar
        unzip
        yt-dlp
        zip
    ];

    networking = {
        firewall.enable = true;
        firewall.checkReversePath = "loose";
        hostName = sysConfig.hostname;
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
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryPackage = pkgs.pinentry-curses;
    };

    security.sudo = {

        execWheelOnly = true;

        extraConfig = /* bash */ ''
            Defaults env_keep += "EDITOR PATH DISPLAY"
            Defaults insults
            Defaults lecture = never
            Defaults passprompt="[31m sudo[0m: password for [36m%p[0m, running as [31m%U[0m: "
            Defaults pwfeedback
        '';

    };

    services = {

        fwupd.enable = true;
        irqbalance.enable = true;
        libinput.enable = true;

        openssh = {

            enable = true;

            knownHosts = {
                "espresso".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKugLnV4qqCMN5dhN4BWEx9Q7OG+BAk0a+2RzNmzFhr root@espresso";
                "gram".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJId64RiXTZvY0oHr75V2TFURT6Qg8D6mgTCGVr59B7l root@gram";
                "magrathea".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKymXBmxO/Yb9lFRyW+w1O3mZ7I6iLgnxW0kgI/4e1O3 root@magrathea";
                "mjolnir".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEsWi8zGLMuMJM+2wawmRFEE6Qmnabq3kA4Rj3bLBBJ6 root@mjolnir";
                "oolong".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIECVKXiwEIQDR5+EJKCDXYNWAE7QZsAmakeDj+htH4FU root@oolong";
            };

            settings = {
                KbdInteractiveAuthentication = false;
                PasswordAuthentication = false;
                PermitRootLogin = lib.mkForce "no";
            };

        };

        tailscale.enable = true;
        timesyncd.enable = true;

    };

    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    sops.defaultSopsFile = ../secrets.yaml;

    system.stateVersion = sysConfig.instalVersion;

    systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

}
