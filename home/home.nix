{ inputs, outputs, lib, config, pkgs, ... }:

{

  imports = [
    ./firefox.nix
    ./steam.nix
    ./gamescope.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = "agentelement";
  home.homeDirectory = "/home/agentelement";

  # First home-manager release this config is compatible with. Do not change.
  home.stateVersion = "23.11"; # Please read the comment before changing.


  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
    ];
  };

  home.packages = with pkgs; [
    # CLI tools
    zsh
    chezmoi
    fastfetch
    lsd
    bat
    delta
    zoxide
    bottom
    neovim
    traceroute
    nmap
    zip
    unzip
    pciutils
    usbutils
    fd
    calcurse
    pdftk

    # Environment
    kitty
    fuzzel
    wl-clipboard
    grim
    slurp

    # GUI tools
    zathura
    openscad
    prusa-slicer
    thunderbird
    signal-desktop
    mpv
    inkscape
    qalculate-gtk
    krita
    libreoffice-qt
    ghidra

    # Devtools
    rustup
    texlive.combined.scheme-full
    (python311.withPackages (ps: with ps; [
      python-lsp-server
      pip
      numpy
    ]))
    clang
    clang-tools

    # Language servers
    texlab
    lua-language-server
    nixd

    # Fonts
    inconsolata
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

    # games
    endless-sky
    prismlauncher
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
    "steamcmd"
  ];

  home.pointerCursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".old_zshrc".source = ../configs/zsh/zshrc;
    ".p10k.zsh".source = ../configs/zsh/p10k.zsh;
    ".config/sway/config".source = ../configs/sway/config;
    ".config/nvim/init.lua".source = ../configs/nvim/init.lua;
    ".config/nvim/lua/cmp_config.lua".source = ../configs/nvim/lua/cmp_config.lua;
    ".config/nvim/lua/keybindings.lua".source = ../configs/nvim/lua/keybindings.lua;
    ".config/nvim/lua/lsp.lua".source = ../configs/nvim/lua/lsp.lua;
    ".config/nvim/lua/plugin_config.lua".source = ../configs/nvim/lua/plugin_config.lua;
    ".config/nvim/lua/plugins.lua".source = ../configs/nvim/lua/plugins.lua;
    ".config/neofetch/config.conf".source = ../configs/neofetch/config.conf;
    ".config/kitty/kitty.conf".source = ../configs/kitty/kitty.conf;
    ".config/i3status-rust/config.toml".source = ../configs/i3status-rust/config.toml;
    ".config/i3status-rust/icons/icon.toml".source = ../configs/i3status-rust/icons/icon.toml;
    ".config/i3status-rust/themes/theme.toml".source = ../configs/i3status-rust/themes/theme.toml;
    ".config/git/config".source = ../configs/git/config;
    ".config/gdb/gdbinit".source = ../configs/gdb/gdbinit;
    ".config/fuzzel/fuzzel.ini".source = ../configs/fuzzel/fuzzel.ini;
    ".config/bg/earth.jpg".source = ../configs/bg/earth.jpg;
  };

  programs.i3status-rust.enable = true;

  programs.fzf.enable = true;

  programs.zsh = {
    initExtra = ''
      source ~/.old_zshrc
    '';
    enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };

  qt = {
    enable = true;
    style = {
      package = pkgs.adwaita-qt;
      name = "adwaita-dark";
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CURRENT_DESKTOP = "sway";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # xdg.desktopEntries.signal = {
  #   exec = "signal --enable-features=UseOzonePlatform --ozone-platform=wayland";
  #   name = "Signal";
  #
  # };
}
