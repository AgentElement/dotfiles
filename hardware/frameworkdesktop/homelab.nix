{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.llama-cpp = {
    enable = true;
    package = (
      pkgs.llama-cpp.override {
        rocmSupport = true;
      }
    );
    host = "0.0.0.0";
    model = "/storage/models/gpt-oss-120b-Q4_K_S-00001-of-00002.gguf";
    extraFlags = [
      "--no-mmap"
      "-ngl"
      "999"
      "-fa"
      "1"
      "--ctx-size"
      "0"
    ];
  };

  environment.systemPackages = with pkgs; [
    (llama-cpp.override {
      rocmSupport = true;
    })
  ];

}
