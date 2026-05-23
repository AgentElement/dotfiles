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

  sops = {
    age.keyFile = "/home/agentelement/.config/sops/age/keys.txt";
    defaultSopsFile = ../../configs/secrets/secrets.yaml;
  };

  sops.secrets."namecheap/api_key" = {};
  sops.secrets."namecheap/api_user" = {};
  sops.secrets."namecheap/client_ip" = {};
  sops.templates."namecheap.env" = {
    content = ''
      NAMECHEAP_API_KEY=${config.sops.placeholder."namecheap/api_key"}
      NAMECHEAP_API_USER=${config.sops.placeholder."namecheap/api_user"}
      NAMECHEAP_CLIENT_IP=${config.sops.placeholder."namecheap/client_ip"}
    '';
    owner = config.services.caddy.user;
    group = config.services.caddy.group;
  };

  systemd.services.caddy.serviceConfig.EnvironmentFile = config.sops.templates."namecheap.env".path;

  networking.firewall.interfaces."wg-homelab".allowedTCPPorts = [
    80
    443
  ];
}
