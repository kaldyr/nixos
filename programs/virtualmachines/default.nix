{
  lib,
  pkgs,
  sysConfig,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    dnsmasq
    phodav
    quickemu
    quickgui
    virglrenderer
    virt-manager
    virt-viewer
    virtiofsd
  ];

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };

  users.users.${sysConfig.user}.extraGroups = [
    "kvm"
    "libvirtd"
  ];
}
