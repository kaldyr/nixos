{
  config,
  sysConfig,
  ...
}:
{
  imports = [ ./${sysConfig}.nix ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    key = config.sops.secrets."syncthing/${sysConfig.hostname}/key.pem".path;
    cert = config.sops.secrets."syncthing/${sysConfig.hostname}/cert.pem".path;

    settings.devices = {
      magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
      mjolnir.id = "2OH2UKZ-YUQIZKC-R3R3KUY-B3T7XDQ-4BPLA2J-LDV5YR4-S3SGBZA-CZ237AZ";
    };
  };

  sops.secrets = {
    "syncthing/${sysConfig.hostname}/cert.pem" = { };
    "syncthing/${sysConfig.hostname}/key.pem" = { };
  };
}
