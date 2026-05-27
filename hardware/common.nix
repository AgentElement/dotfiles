{
  pkgs,
  lib,
  config,
  self,
  ...
}:
{
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

  # Give users access to /storage
  users.groups.storage = { };

  # Give users access to the uinput group. Required for kanata
  users.groups.uinput = { };

  hardware.uinput.enable = true;

  # Install + enable zsh
  programs.zsh.enable = true;

  # The agentelement user (hey, that's me!)
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHgiDj6ZFvu7Ta/4ZQ+c3JZlw/lTj5j3dmVqr11YksFz agentelement@delta"             # delta
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIOJHOJ0FejO0oZEyoXgz61DX98GRmC67PO+xDM0wop agentelement@agentelement.net"  # lambda
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINE4PMpl0z5J6kPkua+40DUqPwYF5wvYKdHbod6xOn7r agentelement@agentelement.net"  # theta
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    gcc
    pulseaudio
    brightnessctl
    gnupg
    podman
    podman-compose
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Query and manipulate storage devices
  services.udisks2.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.jai-jail.enable = true;

  programs.uwsm.enable = true;

  programs.uwsm.waylandCompositors.hyprland = {
    prettyName = "Hyprland";
    comment = "Hyprland compositor managed by UWSM";
    binPath = "/run/current-system/sw/bin/Hyprland";
  };

  services.mullvad-vpn.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "agentelement" ];
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "no";
    };
  };

  networking.nftables.enable = true;
  networking.firewall.extraInputRules = ''
    # Allow SSH from localhost, LAN, and trusted wireguard peers
    ip saddr { 127.0.0.0/8, 10.2.71.0/24, 10.10.10.1, 10.10.10.2, 10.10.10.3 } tcp dport 22 accept

    # Everything else will bypass these input rules and drop.
  '';

  # Ban hosts that cause multiple authentication errors
  services.fail2ban.enable = true;

}
