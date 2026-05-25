{
  pkgs,
  lib,
  config,
  self,
  ...
}:
{
  # Wireguard tunnel
  networking.wg-quick.interfaces.wg-homelab = {
    address = [ "10.10.10.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/home/agentelement/secrets/private.key";
    peers = [
      {
        publicKey = "Kaf4oYavBUD+k/L/RiADIuXPxwZxNoSs83LS5p84gQY=";
        allowedIPs = [ "10.10.10.2/32" ];
      }
      {
        publicKey = "E6cFkFFML8KzFy7TIHolpp6w2MDu2B12JLbkFY79FRg=";
        allowedIPs = [ "10.10.10.3/32" ];
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  # Llama.cpp sits outside a container
  environment.systemPackages = with pkgs; [
    (llama-cpp.override {
      rocmSupport = true;
    })
  ];

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

  sops = {
    age.keyFile = "/home/agentelement/.config/sops/age/keys.txt";
    defaultSopsFile = ../../configs/secrets/secrets.yaml;
  };

  # Enable caddy with namecheap api plugin for SSL certs
  services.caddy = {
    enable = true;
    configFile = ../../configs/caddy/Caddyfile;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/namecheap@v1.0.0" ];
      hash = "sha256-DVztkrHE8+nxYgtjXzEIOW3GRBQN/btINcfFvY5X3lQ=";
    };
  };

  # Construct namecheap.env for caddy to read
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

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  # Containerized services
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  sops.secrets."searxng" = {};
  sops.templates."searxng.env" = {
    content = ''
      SEARXNG_SECRET=${config.sops.placeholder."searxng"}
    '';
    owner = "root";
    group = "root";
  };


  virtualisation.oci-containers.containers.valkey = {
    image = "docker.io/valkey/valkey:9-alpine";
    cmd = [ "valkey-server" "--save" "30" "1" "--loglevel" "warning" ];
    volumes = [
      "searxng-valkey-data:/data"
    ];
    autoStart = true;
  };

  virtualisation.oci-containers.containers.searxng = {
    image = "ghcr.io/searxng/searxng:latest";
    ports = [ "127.0.0.1:8888:8080" ];
    volumes = [
      "${../../configs/searxng/settings.yml}:/etc/searxng/settings.yml:ro"
      "searxng-core-data:/var/cache/searxng"
    ];
    environmentFiles = [ config.sops.templates."searxng.env".path ];
    environment = {
      SEARXNG_BASE_URL = "https://searxng.local.agentelement.net";
    };
    dependsOn = [ "valkey" ];
    autoStart = true;
  };

  virtualisation.oci-containers.containers.searxng-mcp = {
    image = "docker.io/isokoliuk/mcp-searxng:latest";
    ports = [ "127.0.0.1:8889:8080" ];
    environment = {
      SEARXNG_URL = "https://searxng.local.agentelement.net";
      MCP_HTTP_PORT = "8080";
    };
    dependsOn = [ "searxng" ];
    autoStart = true;
  };

  # Uncontainerized services
  services.immich = {
    enable = true;
    port = 2283;
  };

  services.invidious = {
    enable = true;
    port = 3000;
  };


}
