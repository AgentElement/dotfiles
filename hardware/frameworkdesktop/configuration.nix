# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  lib,
  outputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common.nix
    ../syncthing.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.efiSupport = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/8c0c4395-0ccc-49e1-bbf0-1f94f4bdb0d6";
    };
  };

  boot.kernelParams = [
    "ttm.page_pool_size=29696000"
    "ttm.pages_limit=29696000"
    "amdgpu.runpm=0"
    "pcie_aspm=off"
    "pcie_port_pm=off"
    "nvme_core.default_ps_max_latency_us=0"
    "iommu=pt"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_max" = 16777216;
    "net.core.rmem_default" = 1048576;
    "net.core.wmem_default" = 1048576;
    "net.ipv4.tcp_rmem" = "4096 1048576 16777216";
    "net.ipv4.tcp_wmem" = "4096 1048576 16777216";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_window_scaling" = 1;
    "net.core.netdev_max_backlog" = 5000;
  };

  networking.hostName = "theta";

  networking.wg-quick.interfaces = {
    wg-homelab = {
      address = [ "10.10.10.2/32" ];
      privateKeyFile = "/home/agentelement/secrets/secret.key";
      mtu = 1280;
      peers = [
        {
          publicKey = "EnorLZmNE+jA2WuXS36hrHnejgEDQdbYVAMkD9G1rT4=";
          allowedIPs = [ "10.10.10.1/24" ];
          endpoint = "local.agentelement.net:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.interfaces.thunderbolt0 = {
    ipv4.addresses = [
      {
        address = "10.0.0.2";
        prefixLength = 24;
      }
    ];
    mtu = 65520;
  };

  networking.firewall.trustedInterfaces = [ "thunderbolt0" ];

  # Beware, proprietary garbage here.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  # Thunderbolt daemon
  services.hardware.bolt.enable = true;

  # Update firmware
  services.fwupd.enable = true;

  nixpkgs.config.rocmSupport = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
