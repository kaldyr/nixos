{
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user}.xdg.desktopEntries.auto-cpufreq = {
    name = "auto-cpufreq";
    noDisplay = true;
  };

  services.auto-cpufreq = {
    enable = true;

    settings = {
      battery = {
        enforce_platform_profile = true;
        governor = "powersave";
        platform_profile = "low-power";
        turbo = "never";
      };

      charger = {
        enforce_platform_profile = true;
        governor = "powersave";
        platform_profile = "balanced";
        turbo = "always";
      };
    };
  };

systemd.services.rapl-power-limit = {
  description = "Set Intel RAPL sustained package power to 28W";

  serviceConfig = {
    Type = "oneshot";
  };

  script = ''
    rapl=/sys/class/powercap/intel-rapl:0

    test "$(cat "$rapl/constraint_0_name")" = "long_term"
    echo 28000000 > "$rapl/constraint_0_power_limit_uw"
    test "$(cat "$rapl/constraint_0_power_limit_uw")" = "28000000"
  '';
};

systemd.timers.rapl-power-limit = {
  description = "Apply RAPL power limit after boot initialization";

  wantedBy = [ "timers.target" ];

  timerConfig = {
    OnBootSec = "30s";
    Unit = "rapl-power-limit.service";
  };
};
}
