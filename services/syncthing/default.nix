{
  config,
  sysConfig,
  ...
}:
{
  imports = [ ./${sysConfig.hostname}.nix ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    key = config.sops.secrets."syncthing/${sysConfig.hostname}/key.pem".path;
    cert = config.sops.secrets."syncthing/${sysConfig.hostname}/cert.pem".path;
  };

  sops.secrets = {
    "syncthing/${sysConfig.hostname}/cert.pem" = { };
    "syncthing/${sysConfig.hostname}/key.pem" = { };
  };
}
