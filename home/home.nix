{ inputs, outputs, lib, config, pkgs, ... }:

{

  imports = [
    ./firefox.nix
    # ./steam.nix
    # ./gamescope.nix
  ];

  nixpkgs.config.allowUnfree = true;
  home.username = "agentelement";
  home.homeDirectory = "/home/agentelement";

  # First home-manager release this config is compatible with. Do not change.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
    ];
  };

  home.packages = with pkgs; [
    # CLI tools
    zsh                 # Shell
    fastfetch           # Pretty system fetch
    lsd                 # Pretty ls
    bat                 # Pretty cat
    delta               # Pretty diff
    zoxide              # Fuzzy file navigation
    bottom              # System monitor
    neovim              # Text editor
    traceroute          # traceroute
    nmap                # Network scanner
    zip                 # Make zip archives
    unzip               # Unmake zip archives
    pciutils            # lspci
    usbutils            # lsusb
    fd                  # Fuzzy find
    ripgrep             # Fuzzy grep
    calcurse            # Calendar
    pdftk               # PDF toolkit
    pandoc              # Document converter

    # Environment
    kitty               # Terminal emulator
    fuzzel              # Launcher
    wl-clipboard        # CLI interactions with wayland clipboard
    grim                # Grab images from wayland
    slurp               # Select region from wayland
    kanata              # Keymap rebinds 

    # GUI tools
    zathura             # PDF viewer
    openscad            # Solid object modeling language
    prusa-slicer        # STL slicer
    thunderbird         # Email client
    signal-desktop      # Messenger
    mpv                 # Media player
    inkscape            # Vector graphics editor
    qalculate-gtk       # Calculator
    krita               # Raster graphics editor
    libreoffice-qt      # Office suite
    ghidra              # Reverse engineering
    kicad               # EDA suite
    swappy              # Snapshot editor tool

    # Devtools
    rustup                                      # rust
    texlive.combined.scheme-full                # LaTeX
    (python311.withPackages (ps: with ps; [     # python
      pip
      numpy
    ]))
    poetry                                      # python build system
    clang                                       # Cxx compiler, LSP 
    clang-tools                                 # Cxx linter, formatter, etc
    elan                                        # L∃∀N

    # Language servers
    texlab                                      # LaTeX
    lua-language-server                         # lua
    nixd                                        # nix-lang
    llm-ls                                      # language model
    lsp-ai                                      # lanugage model
    pyright                                     # python
    # pylyzer
    ruff                                        # python linter

    # Fonts
    inconsolata
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })

    # games
    endless-sky                                 # Trading game
    prismlauncher                               # Minecraft launcher
  ];

  home.pointerCursor = {
      name = "phinger-cursors-light";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
  };

  # programs.steam.enable = true;
  # programs.steam.gamescopeSession.enable = true;

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
    ".config/kitty/kitty.conf".source = ../configs/kitty/kitty.conf;
    ".config/i3status-rust/config.toml".source = ../configs/i3status-rust/config.toml;
    ".config/i3status-rust/icons/icon.toml".source = ../configs/i3status-rust/icons/icon.toml;
    ".config/i3status-rust/themes/theme.toml".source = ../configs/i3status-rust/themes/theme.toml;
    ".config/git/config".source = ../configs/git/config;
    ".config/gdb/gdbinit".source = ../configs/gdb/gdbinit;
    ".config/fuzzel/fuzzel.ini".source = ../configs/fuzzel/fuzzel.ini;
    ".config/bg/earth.jpg".source = ../configs/bg/earth.jpg;
  };

  # Status bar
  programs.i3status-rust.enable = true;

  # Fuzzy finding
  programs.fzf.enable = true;

  # Enable zsh and source the original .zshrc
  programs.zsh = {
    initExtra = ''
      source ~/.old_zshrc
    '';
    enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome-themes-extra;
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
}
