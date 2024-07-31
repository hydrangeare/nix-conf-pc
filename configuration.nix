{ config, pkgs, inputs, ... }:

let
  user = "hydrangea";
in
{
  imports =
    [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
      ./modules/nvim/nvim-modules.nix
      ./modules/systemd.nix
      ./modules/pc/hardware.nix
      ./modules/audio.nix
      ./modules/udev.nix
      ./modules/hyprland.nix
    ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationLimit = 10;
  boot.loader.timeout = 5;
  boot.kernelPackages = pkgs.linuxPackages_6_8;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;


  networking.hostName = "nixos";
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ]; 
  networking.networkmanager.enable = true; #this 


  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  i18n.inputMethod = {
  type = "fcitx5";
  enable = true;
  fcitx5.waylandFrontend = true;
  fcitx5.addons = with pkgs; [
    fcitx5-gtk
    fcitx5-mozc
    fcitx5-configtool
    ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.pathsToLink = [ "/libexec" ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })
      fira-code
      fira-code-symbols
      font-awesome
      nerdfonts
      dejavu_fonts
      noto-fonts
      noto-fonts-emoji
      ubuntu_font_family
    ];
  };

  environment.variables = {
    IBUS_ENABLE_SYNC_MODE = "1";
    GLFW_IM_MODULE = "ibus";
  };
  environment.sessionVariables = {
  #NIXOS_OZONE_WL = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
  RIDER_VM_OPTIONS = "/home/hydrangea/Application/jetbrains/crack/rider64.vmoptions"; 
  };
    

  hardware.opentabletdriver.enable = true;

  services.printing.enable = true;
  services.libinput.enable = true;
 
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.shellInit = "fastfetch";
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "hydrangea";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
    ];
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  systemd.tmpfiles.rules = [
  
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  
  nixpkgs.config.allowUnfree = true;

  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "${user}" ]; 

  environment.systemPackages = with pkgs; [
    #MAIN 
    	#virtualbox
	htop
	alacritty
	anki-bin
	telegram-desktop
	discord
	docker
	podman
	ventoy
	mediawriter
	mpv
	curl
	distrobox
	wget
	git
	librewolf
	fastfetch
	zsh
	keepassxc
	gparted
	unityhub
	gptfdisk
	dotnet-sdk_8	
	dotnet-runtime_8
	mov-cli
	python311Packages.pip
	fzf
	dotnet-aspnetcore_8
	dotnetPackages.Nuget
	msbuild
	opentabletdriver
	osu-lazer-bin
	ffmpeg
	alsa-lib
	vscodium
	playerctl
	qbittorrent-qt5
        steamPackages.steamcmd
	zplug
	steam
	blender-hip
	blueman
	obs-studio
	v2ray
	gh
	xwayland
	bluez5-experimental 
	bluez-tools
	bluez-alsa
	bluetuith
	spotify
	evince
	libsForQt5.qt5.qtwayland
	libsForQt5.qt5ct
	armcord
	upower
	qt6.qtwayland
	xfce.thunar
	wireguard-tools
	grimblast
	lf
	inkscape
	python3
	krita
	imv
	unzip
	p7zip
	bottles
	pureref
	#OPTIONAL
	waybar-mpris
	ani-cli
	#Hyprland
	wireplumber
	xdg-desktop-portal-hyprland
	xdg-desktop-portal-gtk
	kitty
	pavucontrol
	jq
	rofi
	emacsPackages.alsamixer
	hyprpaper
	tofi
	hyprland
	xdg-desktop-portal-wlr
	dunst
	hyprpicker
	swww
	libnotify
	w3m
	imagemagick
	xdotool
	networkmanagerapplet
	hypridle
	(waybar.overrideAttrs (oldAttrs: {
		mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];	
	}))
	wl-color-picker
        wl-clipboard
  ];
  
  system.stateVersion = "23.11"; # Did you read the comment?

  #HOME_MANAGER
  home-manager = {
  	extraSpecialArgs = { inherit inputs; };
  	users = {
  		"hydrangea" = import ./home.nix;
  	};
  };

  #FLAKES
   nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
}
