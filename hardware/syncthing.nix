{ ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "agentelement";
    dataDir = "/home/agentelement";
    settings = {
      gui.theme = "dark";
      devices = {
        theta = {
          id = "3TZ7W43-DE6UJV2-CVZIB5P-NYRJB4D-6EH4Q7N-ELYXI4X-VSPOSZS-BWED7QS";
        };
        delta = {
          id = "T66RJ7T-UPYCABI-7CWJ7H2-YF2LWSZ-YZGQUBC-D2DAIVL-Y5K5AZQ-P5UGPQN";
        };
      };
      folders = {
        "/storage/archive/" = {
          devices = [
            "theta"
            "delta"
          ];
        };
        "/storage/hardware/" = {
          devices = [
            "theta"
            "delta"
          ];
        };
      };
    };
  };
}
