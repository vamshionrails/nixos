# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vamshi = {
    isNormalUser = true;
    description = "vamshi";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


  # Nvidia 
  services.xserver.videoDrivers = ["amdgpu" "nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true ;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;   
  };

 # Display Manager
 services.greetd = {
  enable = true;
  settings = {
    default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a . %h | %F' --cmd Hyprland";
      user = "greeter";
   };
  };
 };

 # Sound
 sound.enable = true;
 hardware.pulseaudio.enable = true;

 #OpenGL
 hardware.opengl = {
  enable = true;
  driSupport = true;
  driSupport32Bit = true;
  extraPackages = with pkgs;[
    nvidia-vaapi-driver
    libvdpau-va-gl
    vaapiVdpau
   
  ];
 };

 # cuda
 nixpkgs.config.cudaSupport = true;
 # Hyprland
 programs.hyprland.enable = true;
 programs.hyprland.enableNvidiaPatches = true;
 environment.sessionVariables.NIXOS_OZONE_WL = "1";
 environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

# Bluetooth
 hardware.bluetooth.enable = true;
# Thunar
 programs.thunar.enable =true;
 # Waybar
 programs.waybar.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl
    firefox
    pavucontrol
    rofi
    alacritty
    hyprpaper
    dunst
    wlogout
    libGL 
    blueman
    docker
    docker-compose
    htop 
    gwe
    
  ];

  # Fonts
  fonts.packages = with pkgs; [
    dejavu_fonts
    font-awesome
  ];

  #Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
   enable = true;
   setSocketVariable = true;
  };


  # Automatic Garbage Collection
  nix.gc = {
   automatic = true;
   dates = "weekly";
   options = "--delete-older-than 7d";
  };

  #flatpack
  #services.flatpak.enable = true;
  

 # Users
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
