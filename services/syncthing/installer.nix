{
  home-manager.users.matt.home.persistence."/state".directories = [
    ".config/syncthing"
    ".local/state/syncthing"
  ];

  services.syncthing = {
    user = "matt";
    group = "users";
    configDir = "/home/matt/.config/syncthing";
    databaseDir = "/home/matt/.local/state/syncthing";

    settings = {
      devices = {
        gungnir.id = "VLGBL5L-XAFQV3N-GHOFDLI-ZRC6BYT-C5LHRDR-DO4RF46-4TE6ILP-I32OHAT";
        magrathea.id = "F2KB4T5-CFF752T-AWEUVKW-ZUC4JJF-4YZWTLF-KZZE4E6-ZJ3LU3Q-7JC7IQ6";
        mjolnir.id = "2OH2UKZ-YUQIZKC-R3R3KUY-B3T7XDQ-4BPLA2J-LDV5YR4-S3SGBZA-CZ237AZ";
      };

      folders.matt-passwords = {
        path = "/home/matt/.passwords";
        devices = [ "gungnir" "magrathea" "mjolnir" ];
      };
    };
  };
}
