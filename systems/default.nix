{
  config,
  inputs,
  lib,
  pkgs,
  sysConfig,
  ...
}:
{
  imports = [
    ../programs/bat
    ../programs/btop
    ../programs/direnv
    ../programs/fish
    ../programs/fzf
    ../programs/git
    ../programs/lazygit
    ../programs/neovim
    ../programs/qalculate
    ../programs/starship
    ../programs/yazi
    ../programs/zoxide
  ];

  boot.loader = {
    efi.efiSysMountPoint = "/boot";

    grub = {
      enable = true;
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true;
      theme = pkgs.catppuccin-grub.override { flavor = "frappe"; };
      useOSProber = false;
    };
  };

  environment.defaultPackages = lib.mkForce [ ];

  environment.persistence."/state" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      { directory = "/var/lib/tailscale"; mode = "0700"; }
      "/var/log"
    ];
    files = [ "/etc/machine-id" ];
  };


  fileSystems."/nix".neededForBoot = true;
  fileSystems."/state".neededForBoot = true;

  home-manager.users.${sysConfig.user}.home.packages = with pkgs; [
    age
    duf
    exiftool
    eza
    ffmpeg
    ffmpegthumbnailer
    gdu
    gnupg
    jq
    p7zip
    sops
    ssh-to-age
    unrar
    unzip
    yt-dlp
    zip
    zmx
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

    settings = {
      auto-optimise-store = true;
      download-buffer-size = 524288000;
      experimental-features = "nix-command flakes";
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    fuse.userAllowOther = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };

    ssh.extraConfig =
      let
        machines = {
          espresso = "matshkas";
          magrathea = "matt";
          mjolnir = "matt";
        };
      in
      lib.concatStringsSep "\n" (
        lib.mapAttrsToList (hostname: username: ''
          Host ${hostname}
            User ${username}
          Host ${hostname}.*
            HostName ${hostname}
            User ${username}
            RemoteCommand zmx attach %k
            RequestTTY yes
            ControlPath ~/.ssh/cm-%C
            ControlMaster auto
            ControlPersist 10m
        '') machines
        # ++ [ "Include ${config.sops.secrets.ssh-config-extra-hosts.path}" ]
      );
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

    journald.extraConfig = ''
      MaxRetentionSec=7day
    '';

    libinput.enable = true;

    openssh = {
      enable = true;

      allowSFTP = true;
      hostKeys = [{
        path = "/state/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }];


      knownHosts = {
        "espresso".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICKugLnV4qqCMN5dhN4BWEx9Q7OG+BAk0a+2RzNmzFhr root@espresso";
        "magrathea".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKymXBmxO/Yb9lFRyW+w1O3mZ7I6iLgnxW0kgI/4e1O3 root@magrathea";
        "mjolnir".publicKey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEsWi8zGLMuMJM+2wawmRFEE6Qmnabq3kA4Rj3bLBBJ6 root@mjolnir";
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

  sops = {
    age.keyFile = "/state/age/keys.txt";
    age.sshKeyPaths = lib.mkForce [];
    defaultSopsFile = ../secrets.yaml;
    secrets.ssh-config-extra-hosts.mode = "0444";
  };

  system.stateVersion = sysConfig.stateVersion;

  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";
}
