{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    simple-scan
    sane-backends
  ];

  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [ sane-airscan ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
