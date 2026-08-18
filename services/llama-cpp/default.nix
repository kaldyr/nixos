{
  lib,
  pkgs,
  ...
}:
{
  environment.persistence."/state".directories = [ {
    directory = "/var/cache/private";
    mode = "0700";
  } ];

  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp-vulkan;

    settings = {
      host = "127.0.0.1";
      port = 8012;

      gpu-layers = 999;
      ctx-size = 12288;
      threads = 8;
      batch-size = 512;
      ubatch-size = 256;
      flash-attn = "on";
      no-mmap = false;

      models-preset = (pkgs.formats.ini { }).generate "models-preset.ini" {
        "Qwen3.6-27B" = {
          hf-repo = "unsloth/Qwen3.6-27B-GGUF";
          hf-file = "Qwen3.6-27B-Q4_K_M.gguf";
          temp = 0.3;
          top-k = 20;
          top-p = 0.95;
          min-p = 0.0;
          presence-penalty = 0.0;
          repeat-penalty = 1.0;
        };
      };
    };
  };

  systemd.services.llama-cpp = {
    wantedBy = lib.mkForce [ ];
  };
}
