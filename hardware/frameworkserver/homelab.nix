{
  pkgs,
  lib,
  config,
  self,
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
    modelsDir = "/storage/models/";
    extraFlags = [
      "--no-mmap"
      "-ngl"
      "999"
      "-fa"
      "1"
      "--ctx-size"
      "0"
    ];
    port = 8080;
  };

  environment.systemPackages = with pkgs; [
    (llama-cpp.override {
      rocmSupport = true;
    })
  ];

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.immich = {
    enable = true;
    port = 2283;
  };

  services.invidious = {
    enable = true;
    port = 3000;
  };

  services.caddy = {
    enable = true;
    configFile = ../../configs/caddy/Caddyfile;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
