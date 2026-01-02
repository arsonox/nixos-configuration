{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    loadModels = [
      "deepseek-coder-v2"
      "qwen3-vl:8b"
      "gemma3:4b"
    ];
  };
}
