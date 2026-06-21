{
  pkgs,
  lib,
  config,
  self,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.llama-cpp.override {
      rocmSupport = true;
      rpcSupport = true;
    })
  ];

  systemd.services.llama-rpc-server = {
    enable = true;
    description = "llama.cpp rpc";
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "/run/current-system/sw/bin/llama-rpc-server --host 10.0.0.2 -c -p 50052";
    };
  };

  networking.firewall.allowedTCPPorts = [
    50052
  ];

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
}
