{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    libfreeaptx
    ldacbt
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    extraConfig.pipewire."99-bt-latency" = {
      "context.properties" = {
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 2048;
      };
    };

    wireplumber = {
      enable = true;

      extraConfig."10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;

          "bluez5.codecs" = [
            "aac"
            "sbc"
            "sbc_xq"
          ];
        };

        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
  };
}
