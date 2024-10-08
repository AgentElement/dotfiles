{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.programs.gamescope;

  gamescope =
    let
      wrapperArgs =
        optional (cfg.args != [ ]) ''--add-flags "${toString cfg.args}"''
        ++ builtins.attrValues (mapAttrs (var: val: "--set-default ${var} ${val}") cfg.env);
    in
    pkgs.runCommand "gamescope" { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${cfg.package}/bin/gamescope $out/bin/gamescope --inherit-argv0 \
        ${toString wrapperArgs}
    '';
in
{
  options.programs.gamescope = {
    enable = mkEnableOption "gamescope, the SteamOS session compositing window manager";

    package = mkPackageOption pkgs "gamescope" { };

    capSysNice = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Add cap_sys_nice capability to the GameScope
        binary so that it may renice itself.
      '';
    };

    args = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "--rt"
        "--prefer-vk-device 8086:9bc4"
      ];
      description = ''
        Arguments passed to GameScope on startup.
      '';
    };

    env = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = literalExpression ''
        # for Prime render offload on Nvidia laptops.
        # Also requires `hardware.nvidia.prime.offload.enable`.
        {
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        }
      '';
      description = ''
        Default environment variables available to the GameScope process, overridable at runtime.
      '';
    };
  };

  config = mkIf cfg.enable { home.packages = mkIf (!cfg.capSysNice) [ gamescope ]; };

  meta.maintainers = with maintainers; [ nrdxp ];
}
