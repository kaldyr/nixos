{
  pkgs,
  ...
}:
{
  imports = [
    ./desktop.nix
    ../programs/gedit
    ../programs/hyprland
    ../programs/plymouth
    ../services/keyd
    ../services/kmscon
  ];

  environment.systemPackages = with pkgs; [
    disko
  ];

  services = {
    libinput.touchpad.scrollMethod = "twofinger";
    libinput.touchpad.accelSpeed = "-0.5";
  };

  time.timeZone = "America/Los_Angeles";
}
