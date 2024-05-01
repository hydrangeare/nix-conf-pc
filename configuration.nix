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
      ./modules/power_managment.nix
      ./modules/udev.nix
      ./modules/hyprland.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.configurationLimit = 10;
  boot.loader.timeout = 5;
  boot.initrd.kernelModules = [ "amdgpu" ];


  networking.hostName = "nixos";
  networking.networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ]; 
  networking.networkmanager.enable = true;


  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

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

  services.flatpak.enable = true;
  
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" "JetBrainsMono" ]; })
      fira-code
      fira-code-symbols
      font-awesome
      liberation_ttf
      mplus-outline-fonts.githubRelease
      nerdfonts
      noto-fonts
      noto-fonts-emoji
      ubuntu_font_family
      vazir-fonts
    ];
  };
  
  environment.sessionVariables = {
  #NIXOS_OZONE_WL = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
  RIDER_VM_OPTIONS = "/home/hydrangea/Application/jetbrains/crack/rider64.vmoptions"; 
  };
    

  hardware.opentabletdriver.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = pkgs.bluez5-experimental;
      settings.General.Enable = "Source,Sink,Media,Socket";
   };
   services.blueman.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

  };

  programs.noisetorch.enable = true;
  programs.light.enable = true;
  
  services.libinput.enable = true;
 
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.shellInit = "neofetch";
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  

  users.users.${user} = {
    isNormalUser = true;
    description = "hydrangea";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      firefox
    ];
  };

  hardware.opengl = {
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
	  driversi686Linux.amdvlk
    ];
    driSupport = true;
    driSupport32Bit = true;
  };  
  
  systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    #MAIN 
	htop
	alacritty
	anki-bin
	telegram-desktop
	mpv
	curl
	wget
	git
	#unstable.osu-lazer-bin
	osu-lazer-bin
	neofetch
	zsh
	keepassxc
	gparted
	unityhub
	jetbrains.rider
	dotnet-sdk_8
	dotnet-runtime_8
	dotnet-aspnetcore_8
	dotnetPackages.Nuget
	msbuild
	opentabletdriver
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
	(pkgs.waybar.overrideAttrs (oldAttrs: {
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
