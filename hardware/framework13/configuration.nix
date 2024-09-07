# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ pkgs, lib, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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

  networking.hostName = "delta";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Phoenix";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Backlight control
  programs.light.enable = true;

  # Better power management
  services.power-profiles-daemon.enable = true;
  services.udisks2.enable = true;

  # Make the lid switch suspend instead of shut down, suspend after 10 minutes
  # of inactivity
  services.logind = {
    lidSwitch = "suspend";
    extraConfig = ''
      IdleAction=suspend
      IdleActionSec=10m
    '';
  };

  # Language model
  services.ollama.enable = true;
  services.ollama.acceleration = "rocm";

  # Enable sound
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Give users access to /storage
  users.groups.storage = { };

  # Give users access to the uinput group. Required for kanata
  users.groups.uinput = { };

  # Give users access to the plugdev group. Required for crazyradio
  users.groups.uinput = { };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="7777", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1915", ATTRS{idProduct}=="0101", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="5740", MODE="0664", GROUP="plugdev"
  '';

  # Enable uinput
  hardware.uinput.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Install + enable zsh
  programs.zsh.enable = true;

  # The agentelement user (hey, that's me!)
  users.users.agentelement = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "storage"
      "networkmanager"
      "docker"
      "input"
      "uinput"
      "plugdev"
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gcc
    brightnessctl
    pulseaudio
    gnupg
    bluez
  ];

  # Beware, proprietary garbage here.
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  # GPG with ssh support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # login screen
  services.greetd = {
    enable = true;
    settings = {
      default_session.command = ''
        ${pkgs.greetd.tuigreet}/bin/tuigreet \
          --time \
          --asterisks \
          --user-menu \
          --cmd hyprland
      '';
    };
  };

  # Enable nix flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.hyprland.enable = true;

  environment.etc."greetd/environments".text = ''
    hyprland
  '';

  # Required for docker to work correctly
  virtualisation.docker.enable = true;

  # Color management
  services.colord.enable = true;

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
