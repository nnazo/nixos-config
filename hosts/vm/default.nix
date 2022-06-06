{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;

    # Bootloader
    loader = {
      grub = {
        enable = true;
        version = 2;
        efiSupport = true;
        device = "/dev/sda";
        # useOSProber = true;
        # devices = [ "nodev" ];
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };
}