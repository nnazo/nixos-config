{ config, lib, pkgs, user, ... }:

{
  imports = [];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # editors
      vscode
      # development
      rustup
      go
      docker
      docker-compose
      kubectl
      helm
      lens
      glow
      dbeaver
      postman
      # browsers
      firefox-devedition-bin
      google-chrome-dev
      # ime input
      fcitx5
      fcitx5-mozc
      # audio/video
      vlc
      pavucontrol
      # desktop
      latte-dock
      libsForQt5.qtstyleplugin-kvantum
      # misc
      gimp
      libreoffice
      flameshot
      discord
      qbittorrent
      via
      mullvad-vpn
      spotify
    ];

    # pointerCursor = {
    #   name = "Breeze-Cursors";
    #   package = pkgs.libsForQt5.breeze-qt;
    #   size = 24;
    # };

    file.".config/wall".source = ../modules/theme/wall;

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Tela-Circle";
      package = pkgs.tela-circle-icon-theme;
    };
    # font = {
    #   name = "";
    # };
  };
}