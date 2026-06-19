{
  description = "AgentElement's configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    # Nix user repository, mostly for firefox extensions
    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    # Home-manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Community hardware-specific configs
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      home-manager,
      nixos-hardware,
      sops-nix,
      ...
    } @ inputs:
    let
      inherit (self) outputs;
      systems = [ "x86_64-linux" ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = {
        nuroverlay = nur.overlay;
      } // import ./overlays { inherit inputs; };
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      nixosConfigurations = {
        delta = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            nixos-hardware.nixosModules.framework-13-7040-amd
            ./hardware/framework13/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
        theta = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hardware/frameworkdesktop/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
        lambda = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./hardware/frameworkserver/configuration.nix
            sops-nix.nixosModules.sops
          ];
        };
      };

      homeConfigurations = {
        agentelement = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            # use `pkgs.nur` to access nur packages.
            nur.modules.homeManager.default
            inputs.sops-nix.homeManagerModules.sops
            ./home/home.nix
          ];
        };
      };
    };
}
