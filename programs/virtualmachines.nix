{ lib, pkgs, sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user} = lib.mkIf sysConfig.homeImpermanence {
        directories = [
            ".config/libvirt"
            "Machines"
        ];
    };

    environment.systemPackages = with pkgs; [
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
