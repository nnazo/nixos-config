{ lib, inputs, nixpkgs, home-manager, user, location, ... }:
let
  system = "x86_64-linux";
  pkgs = {
    inherit system;
    config.allowUnfree = true;
  };
  lib = nixpkgs.lib;
in {
  vm = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs user location;
    };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        };
      }
    ];
  };
}