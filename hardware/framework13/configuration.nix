# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, lib, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../common.nix
    ../syncthing.nix
  ];

  # Bootloader configuration
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "nodev";
  boot.loader.grub.enable = true;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.efiSupport = true;

  # LUKS on LVM encryption
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/24e1e6e4-5c97-46d1-81af-35f075673d3c";
      preLVM = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "abmlevel=3"
    "amd_pstate=active"
  ];

  # Improve audio quality of speakers
  hardware.framework.laptop13.audioEnhancement.enable = false;

  networking.hostName = "delta";

  networking.wg-quick.interfaces = {
    wg-homelab = {
      address = [ "10.10.10.3/32" ];
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

  # Better power management
  services.power-profiles-daemon.enable = true;

  # Update firmware
  services.fwupd.enable = true;

  # Make the lid switch suspend instead of shut down, suspend after 10 minutes
  # of inactivity
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    IdleAction = "suspend;";
    IdleActionSec = "10m";
  };

  # Udev rules for
  # * Bitcraze crazyfile
  # * Pyocd
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", MODE="0666", GROUP="plugdev"
  '';

  # Enable uinput
  hardware.uinput.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

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

  # Required for docker to work correctly
  virtualisation.docker.enable = true;

  # Color management
  services.colord.enable = true;

  nixpkgs.config.rocmSupport = true;

  # Cap off nix build memory at 90% or else delta will fail to build
  # hipblas/firefox
  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "90%";
    OOMScoreAdjust = 500;
  };

  # Delta is a bit wimpy, so use theta+lambda to build for it.
  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "10.10.10.1";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/remotebuild";
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
    }
    {
      hostName = "10.10.10.2";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/remotebuild";
      system = pkgs.stdenv.hostPlatform.system;
      supportedFeatures = [
        "nixos-test"
        "big-parallel"
        "kvm"
      ];
    }
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
