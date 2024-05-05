{ config, lib, pkgs, user, ... }:

{
  imports = [];

  fonts.fontconfig.enable = true;

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    sessionPath = [
      "$HOME/bin"
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };

    packages = with pkgs; [
      # editors
      vscode

      # development
      rustup
      cargo-edit
      go
      docker
      docker-compose
      kubectl
      kubernetes-helm
      lens
      glow
      dbeaver
      postman
      wget
      gnumake
      zig
      nodejs
      yarn
      
      # browsers
      firefox-devedition-bin
      google-chrome

      # ime input
      fcitx5
      fcitx5-mozc

      # audio/video
      vlc
      pavucontrol

      # misc
      gimp
      libreoffice
      flameshot
      discord
      qbittorrent
      via
      mullvad-vpn
      spotify

      # theme
      dracula-theme
      tela-circle-icon-theme
      nerdfonts

      # util
      usbutils
      ripgrep
      _1password-gui
    ];

    # packages = with pkgs-node11; [
    #   nodejs_11_x
    # ];

    file."bin/git-push-to-target" = {
      source = ./config/git-push-to-target;
      executable = true;
    };
    file.".local/share/konsole/nordic-custom.colorscheme".source = ./theme/nordic-custom.colorscheme;
    file.".local/share/konsole/custom.profile".text = ''
      [Appearance]
      ColorScheme=nordic-custom
      Font=SauceCodePro Nerd Font Mono,11,-1,5,600,0,0,0,0,0,0,0,0,0,0,1,SemiBold

      [General]
      Command=${pkgs.zsh}/bin/zsh
      Name=custom
      Parent=FALLBACK/ 
    '';
    #file.".config/nvim".source = pkgs.fetchFromGitHub {
    #  owner = "nnazo";
    #  repo = "nvim-config";
    #  rev = "v0.7.0";
    #  sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
    #};

    stateVersion = "22.11";
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "nnazo";
      userEmail = "jacobcurtis2266@gmail.com";
      aliases = {
        ptt = "push-to-target";
      };
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = true;
        color.ui = true;
        push.followTags = true;
      };
    };
    neovim = {
      enable = true;
      withPython3 = true;
      vimAlias = true;
      viAlias = true;
    };
    tmux = {
      enable = true;
      extraConfig = ''
        set -g default-terminal "xterm-256color"
        set-option -ga terminal-overrides ",xterm-256color:Tc"
        set -g status-style bg=colour8

        bind-key -n c-n send-prefix 
      '';
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "compleat"
          "golang"
          "rust"
          "docker"
          "docker-compose"
          "docker-machine"
          "vi-mode"
        ];
        extraConfig = ''
          unset TMUX
        '';
      };
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "1g3pij5qn2j7v7jjac2a63lxd97mcsgw6xq6k5p7835q9fjiid98";
          };
        }
        {
	        # syntax highlighting
          name = "F-Sy-H";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-shell";
            repo = "F-Sy-H";
            rev = "v1.6.7";
            sha256 = "0bcsc4kgda577fs3bnvymmxdz3z5mf19pn8ngfqsklabnf79f5nf";
          };
        }
      ];
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    konsole = {
      enable = true;
      defaultProfile = "custom";
      # generate profile manually until font generation is fixed
      #profiles = {
	    #  options = {
      #    name = "custom";
      #    colorScheme = "nordic-custom";
      #    command = "${pkgs.zsh}/bin/zsh";
	    #    font = {
	    #      name = "SauceCodePro Nerd Font Mono SemiBold";
      #      size = 11;
	    #    };
      #  };
      #};
      extraConfig = {
        Scrolling = {
	        HistoryMode = 2;
	        ScrollBarPosition = 2;
	      };
      };
    };

    plasma = {
      enable = true;
      workspace = {
        theme = "Utterly-Nord";
	      lookAndFeel = "Utterly-Nord";
	      colorScheme = "Utterly-Nord";
        cursorTheme = "Dracula-cursor";
	      iconTheme = "Tela-circle";
      	wallpaper = ./theme/wallpaper.png;
      };

      panels = [
        {
	        location = "left";
	        hiding = "dodgewindows";
	        lengthMode = "fit";
	        height = 50;
	        floating = true;
	        alignment = "center";
	        widgets = [
	          {
	            name = "org.kde.plasma.icontasks";
	            config = {
	              General.launchers = [
		              "applications:systemsettings.desktop"
		              "applications:org.kde.dolphin.desktop"
		              "applications:1password.desktop"
		              "applications:org.kde.konsole.desktop"
		              "applications:firefox-developer-edition.desktop"
		              "applications:spotify.desktop"
		              "applications:discord.desktop"
		            ];
	            };
	          }
	        ];
	      }
	      {
	  			location = "top";
	  			height = 32;
	  			floating = true;
	  			alignment = "center";
	  			widgets = [
	    		  "org.kde.plasma.kickoff"
	    			"org.kde.plasma.appmenu"
	    			"org.kde.plasma.panelspacer"
	    			"org.kde.plasma.digitalclock"
	    			"org.kde.plasma.panelspacer"
	    			"org.kde.plasma.systemtray"
	    			"org.kde.plasma.kickoff"
	  			];
				}
      ];
    };
  };

  # gtk = {
    # enable = true;
    # theme = {
      # name = "Dracula";
      # package = pkgs.dracula-theme;
    # };
    # iconTheme = {
      # name = "Tela-Circle";
      # package = pkgs.tela-circle-icon-theme;
    # };
    # font = {
    #   name = "";
    # };
  # };
}
