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
  };

  environment.systemPackages = with pkgs; [
    (llama-cpp.override {
      rocmSupport = true;
    })
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ "agentelement" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
    knownHosts = {
      delta = {
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgiDj6ZFvu7Ta/4ZQ+c3JZlw/lTj5j3dmVqr11YksFz agentelement@delta";
      };
    };
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
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
