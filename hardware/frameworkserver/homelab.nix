{
  pkgs,
  lib,
  config,
  self,
  ...
}:
{
  imports = [
    ../../hosted/invidious/docker-compose.nix
    ../../hosted/searxng/docker-compose.nix
    ../../hosted/immich/docker-compose.nix
    ../../hosted/jellyfin/docker-compose.nix
  ];
  # Wireguard tunnel
  networking.wg-quick.interfaces.wg-homelab = {
    address = [ "10.10.10.1/24" ];
    listenPort = 51820;
    privateKeyFile = "/home/agentelement/secrets/private.key";
    peers = [
      {
        publicKey = "Kaf4oYavBUD+k/L/RiADIuXPxwZxNoSs83LS5p84gQY="; # theta
        allowedIPs = [ "10.10.10.2/32" ];
      }
      {
        publicKey = "E6cFkFFML8KzFy7TIHolpp6w2MDu2B12JLbkFY79FRg="; # delta
        allowedIPs = [ "10.10.10.3/32" ];
      }
      {
        publicKey = "78dssx0YhmMHoHnpiFu6Q1pa+Bg7YXqfJvPRMjgckEE="; # dmp
        allowedIPs = [ "10.10.10.16/32" ];
      }
      {
        publicKey = "Jcr1BMMAWVQyZOKE3ibCrwIuiMOg9sd1dkS+ZXVXHQg="; # vmz
        allowedIPs = [ "10.10.10.17/32" ];
      }
      {
        publicKey = "bRJJBW+cxxqVw7X1+NdiM+FQNmkkpBZCq26PMA4ol3Q="; # gamma
        allowedIPs = [ "10.10.10.18/32" ];
      }
      {
        publicKey = "XMBshQj8JevLxthgYuXax6MJIiT7mpUTwVavuLuvpS8="; # vsz
        allowedIPs = [ "10.10.10.19/32" ];
      }
      {
        publicKey = "9Bgn2BSQ3lZtb2PzgBOaGKX0z0u9G7T02xKW7A+YPn0="; # var
        allowedIPs = [ "10.10.10.128/32" ];
      }
      {
        publicKey = "9FiGGFQ6iNK7LpwyOrNzDffMBsXfeExwoXIWUtNjwh0="; # kpc
        allowedIPs = [ "10.10.10.129/32" ];
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  networking.firewall.trustedInterfaces = [ "thunderbolt0" ];
  networking.interfaces.thunderbolt0 = {
    ipv4.addresses = [
      {
        address = "10.0.0.1";
        prefixLength = 24;
      }
    ];
    # Thunderbolt supports huge MTUs.
    mtu = 65520;
  };

  # Llama.cpp sits outside a container
  environment.systemPackages = with pkgs; [
    (llama-cpp.override {
      rocmSupport = true;
      rpcSupport = true;
    })
  ];

  services.llama-cpp = {
    enable = true;
    package = (
      pkgs.llama-cpp.override {
        rocmSupport = true;
        rpcSupport = true;
      }
    );
    settings = {
      host = "127.0.0.1";
      port = 8080;
      models-preset = "/etc/llama.cpp/preset.ini";
      models-dir = "/storage/models/";
    };
  };

  sops = {
    age.keyFile = "/home/agentelement/.config/sops/age/keys.txt";
    defaultSopsFile = ../../hosted/secrets/secrets.yaml;
  };

  # Enable caddy with namecheap api plugin for SSL certs
  services.caddy = {
    enable = true;
    configFile = ../../hosted/caddy/Caddyfile;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/namecheap@v1.0.0" ];
      hash = "sha256-GuYIhDlUThYXTG02O4W0lTc5fnramYbtYnpCwx9v4rE=";
    };
  };

  # Construct namecheap.env for caddy to read
  sops.secrets."namecheap/api_key" = { };
  sops.secrets."namecheap/api_user" = { };
  sops.secrets."namecheap/client_ip" = { };
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

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # extraPackages = with pkgs; [ podman-compose ];
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.etc =
    builtins.mapAttrs
      (key: value: {
        source = ../../hosted + "/${value}";
      })
      {
        "llama.cpp/preset.ini" = "llama.cpp/preset.ini";
      };

  # remotebuild user
  users.users.remotebuild = {
    isSystemUser = true;
    group = "remotebuild";
    useDefaultShell = true;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWIeSdwVs2pHSyZuVUNZG/zhW97VrVaQAp5ZYZMDjx8 root@delta"
    ];
  };

  users.groups.remotebuild = { };

  nix.settings.trusted-users = [ "remotebuild" ];

  #
  # systemd.services.jellyfin = {
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "podman.service" ];
  #   path = [ pkgs.podman pkgs.podman-compose ];
  #   script = ''
  #     podman compose -f /etc/hosted/jellyfin/docker-compose.yml up
  #   '';
  #   restartTriggers = [
  #     config.environment.etc."hosted/jellyfin/docker-compose.yml".source
  #   ];
  # };
}
