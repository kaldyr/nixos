{ config, lib, pkgs, sysConfig, ... }: {

    imports = [
        ./disko/hofud.nix
        ./modules/desktop.nix
        ./modules/programs/plymouth.nix
        ./modules/programs/steam.nix
    ];

    boot = {

        extraModulePackages = with pkgs; [ btrfs-progs ];

        initrd = {
            availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ]; # Fill out when installing
            kernelModules = [ "amdgpu" ];
        };

        kernelModules = [ "kvm-amd" ];
        kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        kernelParams = [ "btrfs" "quiet" ];

        loader = {

            efi.efiSysMountPoint = "/boot";

            grub = {
                enable = true;
                default = 2;
                device = "nodev";
                efiInstallAsRemovable = true;
                efiSupport = true;
                gfxmodeEfi = "1920x1200,1920x1080";
                theme = pkgs.fetchFromGitHub {
                    owner = "catppuccin";
                    repo = "grub";
                    rev = "803c5df0e83aba61668777bb96d90ab8f6847106";
                    sha256 = "sha256-/bSolCta8GCZ4lP0u5NVqYQ9Y3ZooYCNdTwORNvR7M0=";
                } + "/src/catppuccin-frappe-grub-theme";
                useOSProber = true;
            };

        };

        supportedFilesystems = [ "ntfs" ];

    };

    environment.systemPackages = with pkgs; [ tailscale ];

    # Split this off into default/desktop once testing is done
    environment.persistence = {

        # System files that aren't declarative and need to be preserved
        # Snapshots will back up state
        "/state/system" = {
            directories = [
                { directory = "/etc/NetworkManager/system-connections"; mode = "0700"; }
                { directory = "/var/lib/bluetooth"; mode = "0700"; }
                "/var/lib/nixos"
                "/var/lib/systemd/coredump"
                { directory = "/var/lib/tailscale"; mode = "0700"; }
                "/var/log"
            ];
            files = [
                "/etc/machine-id"
            ];
        };

        # Home files that aren't declarative and need to be preserved
        # Snapshots will back up state
        "/state" = {
            hideMounts = true;
            users.${sysConfig.user} = {
                directories = [
                    ".config/BetterDiscord"
                    ".config/discord"
                    ".config/fish"
                    ".config/libreoffice"
                    ".config/Nextcloud"
                    ".config/sops/age"
                    { directory = ".config/obsidian"; mode = "0700"; }
                    { directory = ".gnupg"; mode = "0700"; }
                    ".local/share/applications"
                    ".local/share/fish"
                    { directory = ".local/share/keyrings"; mode = "0700"; }
                    ".local/share/zoxide"
                    ".local/share/Nextcloud"
                    ".local/state/nvim"
                    { directory = ".mozilla"; mode = "0700"; }
                    { directory = ".ssh"; mode = "0700"; }
                ];
            };
        };

        # Home files that need to be preserved between boots
        #  These files do not need to be backed up
        # Syncthing and Nextcloud handle the personal files
        # Steam and Telegram can just re-download data on drive restore
        "/nix" = {
            hideMounts = true;
            users.${sysConfig.user} = {
                directories = [
                    "Audiobooks"
                    "Books"
                    "Documents"
                    "Downloads"
                    "Music"
                    "Notes"
                    "Pictures"
                    "Projects"
                    "Videos"
                    ".local/share/Steam"
                    ".local/share/TelegramDesktop"
                ];
            };
        };

    };

    hardware = {
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        enableRedistributableFirmware = true;
        enableAllFirmware = true;
    };

    networking.hostName = sysConfig.hostname;
    nixpkgs.config.allowUnfree = true;
    time.timeZone = "America/Los_Angeles";

    services = {

        auto-cpufreq = {
            enable = true;
            settings = {
                battery.governor = "powersave";
                battery.turbo = "never";
                charger.governor = "performance";
                charger.turbo = "auto";
            };
        };

        fwupd.enable = true;
        tailscale.enable = true;
        thermald.enable = true;

        xserver = {
            videoDrivers = [ "amdgpu" ];
            libinput = {
                enable = true;
                touchpad.scrollMethod = "twofinger";
                touchpad.accelSpeed = "-0.5";
            };
        };

    };

}
