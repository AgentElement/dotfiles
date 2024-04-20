{
  description = "Configuration files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: 
  let inherit (self) outputs; 
  in 
  {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      delta = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hardware/framework13/configuration.nix];
      };
    };

    homeConfigurations = {
      agentelement = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/home.nix];
      };
    };

  };
}
