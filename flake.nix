{
  description = "My NixOS flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }: 
    let
      user = "jacob";
      location = "$HOME/nixos-config"; 
    in {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user location;
        }
      );

      # homeConfigurations = (
      #   import ./nix {
      #     inherit (nixpkgs) lib;
      #     inherit inputs nixpkgs home-manager user;
      #   }
      # );
      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      # defaultPackage.x86_64-linux = self.packages.x86_64-linux.hello;

    };
}
