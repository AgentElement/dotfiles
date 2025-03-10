{
  description = "AgentElement's configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nur.url = "github:nix-community/nur";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    textfox.url = "github:adriankarlen/textfox";
  };

  outputs =
    {
      self,
      nixpkgs,
      nur,
      home-manager,
      textfox,
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
          modules = [ ./hardware/framework13/configuration.nix ];
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
            textfox.homeManagerModules.default
            ./home/home.nix
          ];
        };
      };
    };
}
