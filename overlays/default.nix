# This file defines overlays
{inputs, ...}: {
  # Bring in custom packages from the 'pkgs' directory
  additions = final: prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
      # This overlay passes a few arguments to the signal-desktop binary
      # in the signal-desktop.desktop file. The postInstall hook executes 
      # *before* the preFixup in
      #
      # https://github.com/NixOS/nixpkgs/blob/34621afb912baea67575c63836a11671e5ea2b0d/pkgs/applications/networking/instant-messengers/signal-desktop/generic.nix#L159
      #
      # and therefore instead of substituting /bin/signal-desktop,
      # we must substitute /opt/Signal/signal-desktop (the location that 
      # signal-desktop expects to be placed)

      signal-desktop = prev.signal-desktop.overrideAttrs (oldAttrs: {
        postInstall = (oldAttrs.postInstall or "") + ''
          substituteInPlace $out/share/applications/signal-desktop.desktop --replace-fail "/opt/Signal/signal-desktop" "/opt/Signal/signal-desktop --enable-features=UseOzonePlatform --ozone-platform=wayland"
        '';
      });
    };
}
