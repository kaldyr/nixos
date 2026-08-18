{
  lib,
  pkgs,
  ...
}:
{
  environment.persistence."/state" = {
    directories = [
      "/var/lib/stable-diffusion-cpp"
      "/var/cache/stable-diffusion-cpp"
    ];
  };

  environment.systemPackages = with pkgs; [ stable-diffusion-cpp-vulkan ];

  systemd.services.stable-diffusion-cpp = {
    description = "Stable Diffusion image generation server (sd-server)";

    after = [ "network.target" ];
    wantedBy = [ ];

    conflicts = [ "llama-cpp.service" ];

    serviceConfig = {
      Type = "simple";
      StateDirectory = "stable-diffusion-cpp";
      CacheDirectory = "stable-diffusion-cpp";
      WorkingDirector = "/var/lib/stable-diffusion-cpp";

      ExecStart =
        let
          pkg = pkgs.stable-diffusion-cpp-vulkan;
          args = [
            "--listen-ip"
            "mjolnir"
            "--listen-port"
            "8081"
            "--model"
            "/var/cache/stable-diffusion-cpp/v1-5-pruned-emaonly.safetensors"
          ];
        in
        "${pkg}/bin/sd-server ${lib.escapeShellArgs args}";

      ReadWritePaths = [
        "/var/lib/stable-diffusion-cpp"
        "/var/cache/stable-diffusion-cpp"
      ];
    };

  };
}
