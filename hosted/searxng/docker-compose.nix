# This file was handwritten, instead of making a docker-compose.yml and
# running it through compose2nix
# https://docs.searxng.org/admin/installation-docker.html

{
  pkgs,
  lib,
  config,
  ...
}:
{
  sops.secrets."searxng" = { };
  sops.templates."searxng.env" = {
    content = ''
      SEARXNG_SECRET=${config.sops.placeholder."searxng"}
    '';
    owner = "root";
    group = "root";
  };

  # Database service
  virtualisation.oci-containers.containers.valkey = {
    image = "docker.io/valkey/valkey:9-alpine";
    cmd = [
      "valkey-server"
      "--save"
      "30"
      "1"
      "--loglevel"
      "warning"
    ];
    volumes = [
      "searxng-valkey-data:/data"
    ];
    autoStart = true;
  };

  # Main searxng container
  virtualisation.oci-containers.containers.searxng = {
    image = "ghcr.io/searxng/searxng:latest";
    ports = [ "127.0.0.1:8888:8080" ];
    volumes = [
      "${../../hosted/searxng/settings.yml}:/etc/searxng/settings.yml:ro"
      "searxng-core-data:/var/cache/searxng"
    ];
    environmentFiles = [ config.sops.templates."searxng.env".path ];
    environment = {
      SEARXNG_BASE_URL = "https://searxng.local.agentelement.net";
    };
    dependsOn = [ "valkey" ];
    autoStart = true;
  };

  # This runs an mcp server for language models to interact with searxng
  virtualisation.oci-containers.containers.searxng-mcp = {
    image = "docker.io/isokoliuk/mcp-searxng:latest";
    ports = [ "127.0.0.1:8889:8080" ];
    environment = {
      SEARXNG_URL = "https://searxng.local.agentelement.net";
      MCP_HTTP_PORT = "8080";
    };
    dependsOn = [ "searxng" ];
    autoStart = true;
  };
}
