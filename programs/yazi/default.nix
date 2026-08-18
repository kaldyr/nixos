{
  config,
  pkgs,
  sysConfig,
  ...
}:
let
  baseConfig = config;
in
{
  home-manager.users.${sysConfig.user} = { config, ... }: {
    home.file.".local/share/yazi/sshfs.list".source =
      config.lib.file.mkOutOfStoreSymlink
        baseConfig.sops.secrets.yazi-sshfs-list.path;

    home.packages = with pkgs; [
      glow
      mediainfo
      ouch
      sshfs
      yazi
    ];

    xdg.configFile."yazi".source =
      config.lib.file.mkOutOfStoreSymlink "/nix/config/programs/yazi/config";
  };

  programs.fuse.enable = true;

  sops.secrets.yazi-sshfs-list = {
    owner = sysConfig.user;
    mode = "0440";
  };
}
