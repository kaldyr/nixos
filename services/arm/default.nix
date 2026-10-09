{
  pkgs,
  sysConfig,
  ...
}:
let
  armUid = 975;
  armGid = 975;

  mediaDir =
    if sysConfig.hostname == "magrathea" then
      "/storage/media"
    else
      "/media";

  stateDir = "/var/lib/arm";
  rippingDir = "/scratch/arm";
  processDir = "${mediaDir}/Process";

  opticalDevice = "/dev/sr0";
  genericDevice = "/dev/arm-optical-sg";

  serviceHost = service:
    if sysConfig.hostname == "magrathea" then service
    else "${sysConfig.hostname}-${service}";

  webPort = 8081;

  armConfig = pkgs.writeText "arm.yaml" ''
    ARM_NAME: "${sysConfig.hostname}"
    UI_BASE_URL: "https://${serviceHost "arm"}.brill-godzilla.ts.net"

    # Identification
    GET_VIDEO_TITLE: true
    GET_AUDIO_TITLE: "musicbrainz"
    VIDEOTYPE: "auto"
    METADATA_PROVIDER: "omdb"

    MANUAL_WAIT: true
    MANUAL_WAIT_TIME: 60
    ALLOW_DUPLICATES: true

    # Include short TV episodes
    MINLENGTH: "120"
    MAXLENGTH: "99999"

    # Disc processing
    AUTO_EJECT: true
    UMASK: 0o002

    RIPMETHOD: "mkv"
    MAINFEATURE: false
    DELRAWFILES: true

    SKIP_TRANSCODE: false

    MAX_CONCURRENT_TRANSCODES: 1
    DEST_EXT: "mkv"

    ABCDE_CONFIG_FILE: "/etc/arm/config/abcde.conf"

    RAW_PATH: "/home/arm/media/raw/"
    TRANSCODE_PATH: "/home/arm/media/transcode/"
    COMPLETED_PATH: "/home/arm/media/completed/"

    INSTALLPATH: "/opt/arm/"
    LOGPATH: "/home/arm/logs/"
    DBFILE: "/home/arm/db/arm.db"

    WEBSERVER_IP: "x.x.x.x"
    WEBSERVER_PORT: 8080
    DISABLE_LOGIN: false

    LOGLEVEL: "INFO"

    # Handbrake settings
    HB_PRESET_DVD: "HQ 720p30 Surround"

    HB_ARGS_DVD: >-
      --encoder svt_av1_10bit
      --encoder-preset 4
      --quality 24
      --aencoder opus
      --ab 192
      --mixdown stereo
      --audio 1
      --auto-anamorphic
      --comb-detect
      --decomb
      --detelecine
      --vfr
      --all-subtitles
  '';

  abcdeConfig = pkgs.writeText "abcde.conf" ''
    CDDBMETHOD=musicbrainz

    OUTPUTTYPE=flac
    FLACOPTS="-8"

    OUTPUTDIR="/home/arm/music"

    PADTRACKS=y
    INTERACTIVE=n

    OUTPUTFORMAT='${"$"}{ARTISTFILE}/${"$"}{ALBUMFILE}/${"$"}{TRACKNUM} - ${"$"}{TRACKFILE}'
    VAOUTPUTFORMAT='Various/${"$"}{ALBUMFILE}/${"$"}{TRACKNUM} - ${"$"}{ARTISTFILE} - ${"$"}{TRACKFILE}'
  '';

  waitForDrives = pkgs.writeShellScript "arm-wait-for-drives" ''
    for i in $(${pkgs.coreutils}/bin/seq 1 30); do
      if [ -e "${opticalDevice}" ] &&
         [ -e "${genericDevice}" ]; then
        exit 0
      fi

      ${pkgs.coreutils}/bin/sleep 1
    done

    echo "ARM: optical drive devices unavailable" >&2
    exit 1
  '';
in
{
  boot.kernelModules = [ "sg" ];

  # Stable generic SCSI device for the single optical drive.
  # Does not trigger ripping.
  services.udev.extraRules = ''
    SUBSYSTEM=="scsi_generic", KERNEL=="sg*", ATTRS{type}=="5", SYMLINK+="arm-optical-sg"
  '';

  systemd.tmpfiles.rules = [
    # Persistent state
    "d ${stateDir} 0750 arm arm -"
    "d ${stateDir}/db 0750 arm arm -"
    "d ${stateDir}/logs 0750 arm arm -"
    "d ${stateDir}/config 0750 arm arm -"

    # SSD workspace
    "d ${rippingDir} 0750 arm arm -"
    "d ${rippingDir}/raw 0750 arm arm -"
    "d ${rippingDir}/transcode 0750 arm arm -"

    # Completed media
    "d ${processDir} 2775 arm media -"
    "d ${processDir}/Music 2775 arm media -"

    # Copy declarative config into writable state
    "C+ ${stateDir}/config/arm.yaml 0644 arm arm - ${armConfig}"
    "C+ ${stateDir}/config/abcde.conf 0644 arm arm - ${abcdeConfig}"
  ];

  virtualisation = {
    docker.enable = true;

    oci-containers = {
      backend = "docker";

      containers.arm = {
        image = "automaticrippingmachine/automatic-ripping-machine:latest";

        autoStart = true;

        ports = [
          "127.0.0.1:${toString webPort}:8080"
        ];

        environment = {
          ARM_UID = toString armUid;
          ARM_GID = toString armGid;
          TZ = "America/Los_Angeles";
        };

        volumes = [
          # Persistent application state
          "${stateDir}:/home/arm"
          "${stateDir}/config:/etc/arm/config"

          # Temporary SSD workspace
          "${rippingDir}:/home/arm/media"

          # Completed video on media storage
          "${processDir}:/home/arm/media/completed"

          # Completed music CDs
          "${processDir}/Music:/home/arm/music"
        ];

        extraOptions = [
          "--device=${opticalDevice}:/dev/sr0"
          "--device=${genericDevice}:/dev/sg0"

          # Initial compatibility setting.
          # Restrict after successful device-access tests.
          "--privileged"
        ];
      };
    };
  };

  systemd.services.docker-arm = {
    requires = [ "systemd-tmpfiles-setup.service" ];
    after = [ "systemd-tmpfiles-setup.service" ];

    unitConfig.RequiresMountsFor = [
      stateDir
      rippingDir
      processDir
    ];

    serviceConfig.ExecStartPre = [ waitForDrives ];
  };

  users = {
    groups.arm.gid = armGid;

    users.arm = {
      uid = armUid;
      group = "arm";

      extraGroups = [
        "media"
        "cdrom"
      ];

      home = stateDir;
      isSystemUser = true;
      createHome = false;
    };
  };
}
