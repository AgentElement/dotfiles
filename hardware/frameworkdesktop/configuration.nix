# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./homelab.nix
  ];

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
    "amd_iommu=off"
    "amdgpu.gttsize=108000"
    "ttm.pages_limit=33554432"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "theta";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable sound
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.groups.storage = { };
  users.groups.uinput = { };

  hardware.uinput.enable = true;

  programs.zsh.enable = true;

  users.users.agentelement = {
    isNormalUser = true;
    extraGroups = [
      "dialout"
      "wheel"
      "video"
      "storage"
      "networkmanager"
      "input"
      "uinput"
      "podman"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gcc
    pulseaudio
    gnupg
    podman
    podman-compose
  ];

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

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Thunderbolt daemon
  services.hardware.bolt.enable = true;

  # Query and manipulate storage devices
  services.udisks2.enable = true;

  # Update firmware
  services.fwupd.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.uwsm.enable = true;
  programs.uwsm.waylandCompositors.hyprland = {
    prettyName = "Hyprland";
    comment = "Hyprland compositor managed by UWSM";
  };


  services.mullvad-vpn.enable = true;
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
