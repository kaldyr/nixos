{ config, inputs, lib, pkgs, sysConfig, ... }: {

    imports = [
        ../programs/bat.nix
        ../programs/btop.nix
        ../programs/direnv.nix
        ../programs/eza.nix
        ../programs/fish.nix
        ../programs/fzf.nix
        ../programs/git.nix
        ../programs/helix.nix
        ../programs/lazygit.nix
        ../programs/neovim.nix
        ../programs/starship.nix
        ../programs/yazi.nix
        # ../programs/zellij.nix
        ../programs/zoxide.nix
    ];

    # Temp fix for [nixpkg merge](https://github.com/NixOS/nixpkgs/pull/351151) causing problems with impermenance.
    boot.initrd.systemd.suppressedUnits = [ "systemd-machine-id-commit.service" ];
    systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

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
                rev = "88f6124757331fd3a37c8a69473021389b7663ad";
                sha256 = "sha256-e8XFWebd/GyX44WQI06Cx6sOduCZc5z7/YhweVQGMGY=";
            } + "/src/catppuccin-frappe-grub-theme";

            useOSProber = false;

        };

    };

    environment = {

        defaultPackages = lib.mkForce [];

        # Home files that aren't declarative and need to be preserved
        persistence."/state" = {

            hideMounts = true;

            users.${sysConfig.user}.directories = [
                { directory = ".config/sops/age"; mode = "0700"; }
                { directory = ".gnupg"; mode = "0700"; }
                { directory = ".local/share/keyrings"; mode = "0700"; }
                { directory = ".ssh"; mode = "0700"; }
            ];

        };

        # System files that aren't declarative and need to be preserved
        persistence."/state/system" = {

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
        bc
        duf
        exiftool
        fd
        ffmpeg
        ffmpegthumbnailer
        htmlq
        gdu
        jq
        lazysql
        p7zip
        ripgrep
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
        libinput.enable = true;

        openssh = {

            enable = true;

            knownHosts = {
                "garm".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJId64RiXTZvY0oHr75V2TFURT6Qg8D6mgTCGVr59B7l root@gram";
                "magrathea".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKymXBmxO/Yb9lFRyW+w1O3mZ7I6iLgnxW0kgI/4e1O3 root@magrathea";
                "mjolnir".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEsWi8zGLMuMJM+2wawmRFEE6Qmnabq3kA4Rj3bLBBJ6 root@mjolnir";
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

    systemd.extraConfig = /* bash */ ''
        DefaultTimeoutStopSec=10s
    '';

}
