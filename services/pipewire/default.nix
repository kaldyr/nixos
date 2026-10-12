{
  pkgs,
  ...
}:
{

  environment.systemPackages = with pkgs; [
    libfreeaptx
    ldacbt
  ];

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;

      extraConfig."10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;

          "override.bluez5.codecs" = [
            "aac"
            "sbc"
            "sbc_xq"
            "ldac"
          ];
        };

        "monitor.bluez.rules" = [
          {
            matches = [ { "device.name" = "~bluez_card.*"; } ];

            actions."update-props" = {
              "bluez5.a2dp.ldac.quality" = "sq";
            };
          }
        ];

        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
    };
  };
}
