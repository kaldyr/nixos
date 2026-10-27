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
      battery.governor = "powersave";
      battery.turbo = "never";
      charger.governor = "performance";
      charger.turbo = "auto";
    };
  };
}
