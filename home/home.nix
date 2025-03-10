{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./firefox.nix
  ];

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
    dust                # Pretty du
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
    yq                  # YAML/JSON/XML/CSV/TOML processor
    calcurse            # Calendar
    pdftk               # PDF toolkit
    pandoc              # Document converter
    imagemagick         # Image manipulation suite
    playerctl           # Manage media players implementing the MPRIS dbus spec

    # Environment
    kitty               # Terminal emulator
    wl-clipboard        # CLI interactions with wayland clipboard
    grim                # Grab images from wayland
    slurp               # Select region from wayland
    kanata              # Keymap rebinds
    wev                 # Keycode viewer
    hyprpicker          # Color picker
    localsend           # Share files between devices over wifi
    dunst               # Notification daemon
    udiskie             # Automount mass storage devices

    # GUI tools
    kdePackages.okular  # PDF viewer
    prusa-slicer        # STL slicer
    thunderbird         # Email client
    signal-desktop      # Messenger
    vlc                 # Media player
    kdePackages.gwenview# Image viewer
    inkscape            # Vector graphics editor
    qalculate-gtk       # Calculator
    krita               # Raster graphics editor
    libreoffice-qt      # Office suite
    ghidra              # Reverse engineering
    kicad               # EDA suite
    freecad             # CAD suite
    openscad            # Solid object modeling language
    swappy              # Snapshot editor tool
    pavucontrol         # Volume control
    blueman             # Bluetooth control

    # Devtools
    rustup                                      # rust
    texlive.combined.scheme-full                # LaTeX
    (python312.withPackages (
      ps:                                       # python
      with ps; [
        pip
        numpy
      ]
    ))
    uv                                          # python build system
    clang                                       # Cxx compiler, LSP
    clang-tools                                 # Cxx linter, formatter, etc
    elan                                        # L∃∀N
    typst                                       # Is LaTeX really that bad?
    hugo                                        # Site generator
    gnumake                                     # Good ol' make
    llama-cpp                                   # Bleh
    gdb                                         # good debugger

    # Language servers
    texlab                                      # LaTeX lsp
    lua-language-server                         # lua lsp
    nixd                                        # nix-lang lsp
    pyright                                     # python lsp
    # pylyzer                                   # python lsp
    ruff                                        # python linter
    tinymist                                    # typst lsp

    # Fonts
    inconsolata
    nerd-fonts.symbols-only

    # games
    endless-sky                                 # Trading game
    prismlauncher                               # Minecraft launcher

    # One of the earliest memories I have is of of writing this program in the
    # LOGO language.
    #
    #   repeat 36 [repeat 360 [forward 1 right 1] right 10]
    #
    # If you are reading this, try it out yourself!
    ucblogo
  ];


  home.pointerCursor = {
    name = "phinger-cursors-light";
    package = pkgs.phinger-cursors;
    size = 24;
    gtk.enable = true;
  };

  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file =
    builtins.mapAttrs
      (key: value: {
        # symlink ~/dotfiles/configs/{value} to ~/{key}
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/${value}";
      })
      {
        ".old_zshrc"                                = "zsh/zshrc";
        ".p10k.zsh"                                 = "zsh/p10k.zsh";
        ".config/sway/config"                       = "sway/config";
        ".config/nvim/init.lua"                     = "nvim/init.lua";
        ".config/nvim/lua/cmp_config.lua"           = "nvim/lua/cmp_config.lua";
        ".config/nvim/lua/keybindings.lua"          = "nvim/lua/keybindings.lua";
        ".config/nvim/lua/lsp.lua"                  = "nvim/lua/lsp.lua";
        ".config/nvim/lua/plugin_config.lua"        = "nvim/lua/plugin_config.lua";
        ".config/nvim/lua/plugins.lua"              = "nvim/lua/plugins.lua";
        ".config/kitty/kitty.conf"                  = "kitty/kitty.conf";
        ".config/i3status-rust/config.toml"         = "i3status-rust/config.toml";
        ".config/i3status-rust/icons/icon.toml"     = "i3status-rust/icons/icon.toml";
        ".config/i3status-rust/themes/theme.toml"   = "i3status-rust/themes/theme.toml";
        ".config/git/config"                        = "git/config";
        ".config/gdb/gdbinit"                       = "gdb/gdbinit";
        ".config/fuzzel/fuzzel.ini"                 = "fuzzel/fuzzel.ini";
        ".config/bg/earth.jpg"                      = "bg/earth.jpg";
        ".config/kanata/kanata.kbd"                 = "kanata/kanata.kbd";
        ".config/hypr/hyprland.conf"                = "hypr/hyprland.conf";
        ".config/waybar/config.jsonc"               = "waybar/config.jsonc";
        ".config/waybar/style.css"                  = "waybar/style.css";
        ".config/dunst/dunstrc"                     = "dunst/dunstrc";
      };

  # Launcher
  programs.fuzzel.enable = true;

  # Status bar
  programs.waybar.enable = true;

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
    font = {
      size = 9;
      name = "Noto Sans";
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
    XDG_CURRENT_DESKTOP = "Hyprland";
  };

  # Media control for mpris-compatible media players (mpv, firefox, etc)
  services.mpris-proxy.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;


  systemd.user.services.llama-cpp = {
    Unit = {
        Description = "Run a small language model";
    };
    Install = {
        WantedBy = [ "default.target" ];
    };
    Service = {
        ExecStart = "${pkgs.writeShellScript "llama-cpp" ''
            #!/run/current-system/sw/bin/bash
            llama-server \
                -hf ggml-org/Qwen2.5-Coder-1.5B-Q8_0-GGUF \
                --port 8012 -ngl 99 -fa -ub 1024 -b 1024 \
                --ctx-size 0 --cache-reuse 256
        ''}";
    };
  };
}
