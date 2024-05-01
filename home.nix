  #HOME_MANAGER
  { config, pkgs, lib , ... }:
  {
    home.stateVersion = "23.11"; 

    home.file.".p10k.zsh" = {
      source = ./dots/p10k/p10k.zsh;
      executable = true;
    };

    home.file."config/dunstrc".source = ./dots/dunst;
    home.file."config/tofi".source = ./dots/tofi;
    home.file."config/waybar".source = ./dots/waybar;
    home.file."config/alacritty".source = ./dots/alacritty;
    home.file."config/hyprland".source = ./dots/hypr;

    home.activation = {
      # https://github.com/philj56/tofi/issues/115#issuecomment-1701748297
      regenerateTofiCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        tofi_cache=${config.xdg.cacheHome}/tofi-drun
        [[ -f "$tofi_cache" ]] && rm "$tofi_cache"
      '';
    };
    
#    xdg.desktopEntries = {
#    	discord = {
#    		name = "Discord";
#    		genericName = "idk video messenger";
#    		exec = "discord  --enable-features=UseOzonePlatform --ozone-platform=wayland"; 	
#    		terminal = false;
#    	};	
#    };
    
    gtk.enable = true;
    gtk.theme.package = pkgs.graphite-gtk-theme;
    gtk.theme.name = "Graphite-Dark";
    gtk.cursorTheme.package = pkgs.bibata-cursors;
    gtk.cursorTheme.name = "Bibata-Modern-Ice";
    
    programs.obs-studio = {
    	enable = true;
    	plugins = with pkgs.obs-studio-plugins; [
    		wlrobs
    		obs-backgroundremoval
    		obs-pipewire-audio-capture
    	];
    };
    
    programs.alacritty.enable = true;
	
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake /etc/nixos/.#hydrangea";
        nix-conf = "sudo nvim /etc/nixos/configuration.nix";
        hypr-conf = "nvim $HOME/.config/hypr/hyprland.conf";
        wayb-conf = "nvim $HOME/.config/waybar/config";
      };

	  initExtra = ''
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';

      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; } 
          { name = "romkatv/powerlevel10k"; tags = [ "as:theme" "depth:1" ]; } # Corrected punctuation here
        ];
      };
    };
    
  }
