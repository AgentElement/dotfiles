{
  pkgs,
  lib,
  config,
  self,
  ...
}:
{
  networking.wg-quick.interfaces.wg-homelab = {
    address = [ "10.10.10.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/home/agentelement/secrets/private.key";
    peers = [
      # {
      #   publicKey = "";
      #   allowedIPs = [ "10.10.10.2/24" ];
      # }
      {
        publicKey = "E6cFkFFML8KzFy7TIHolpp6w2MDu2B12JLbkFY79FRg=";
        allowedIPs = [ "10.10.10.3/24" ];
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

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
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/namecheap@v1.0.0" ];
      hash = "sha256-DVztkrHE8+nxYgtjXzEIOW3GRBQN/btINcfFvY5X3lQ=";
    };
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = "/home/agentelement/secrets/namecheap.env";

  networking.firewall.interfaces."wg-homelab".allowedTCPPorts = [
    80
    443
  ];
}
