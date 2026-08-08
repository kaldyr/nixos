{
  lib,
  pkgs,
  sysConfig,
  ...
}:
{

  environment.persistence."/nix/system" = lib.mkIf sysConfig.systemImpermanence {
    directories = [
    ];
  };

  environment.systemPackages = with pkgs; [
    openvino
    openvino-genai
    openvino-tokenizers
  ];

  # "Qwen3.6-27B" = {
  #     hf-repo = "unsloth/Qwen3.6-27B-GGUF";
  #     hf-file = "Qwen3.6-27B-Q4_K_M.gguf";
  #     temp = 0.3;
  #     top-k = 20;
  #     top-p = 0.95;
  #     min-p = 0.0;
  #     presence-penalty = 0.0;
  #     repeat-penalty = 1.0;
  # };

  systemd.services."openvino" = {
    description = "OpenVINO local AI";

    after = [ "graphical.target" ];
    wants = [ "graphical.target" ];
    wantedBy = [ ];

    environment = { };

    serviceConfig.type = "oneshot";

    script = "";
  };
}
