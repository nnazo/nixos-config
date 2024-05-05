{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgsStable.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # https://github.com/NixOS/nixpkgs/blob/29839c374a977ac801724293565208c532afb245/pkgs/development/web/nodejs/v11.nix
    # nixpkgs-node11.url = "github:NixOS/nixpkgs/29839c374a977ac801724293565208c532afb245";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = { self, nixpkgs, nixpkgsStable, home-manager, plasma-manager, ... }@inputs: let
    host = "nixos";
    user = "jacob";
    system = "x86_64-linux";
  in {
    # Please replace nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "${system}";
      specialArgs = {
        inherit inputs host user;
        # pkgs-stable = import nixpkgs-stable {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
        # pkgs-node11 = import nixpkgs-node11 {
        #   inherit system;
        #   config.allowUnfree = true;
        # };
      };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users."${user}" = import ./home.nix;
	        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
          home-manager.backupFileExtension = "backup";

          # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
          home-manager.extraSpecialArgs = { inherit inputs host user; };
        }
      ];
    };
  };
}
