# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
    sources = import ./nix/sources.nix;
    lanzaboote = import sources.lanzaboote;
    overpass-api = pkgs.callPackage ./overpass/overpass.nix {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      #./overpass/overpass-backend.nix
      lanzaboote.nixosModules.lanzaboote
      # Include home manager
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Bluetooth gui
  services.blueman.enable = true;

  # Printer stuff
  services.printing.enable = true;

  # Droidcam setup
  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModulePackages = [
    pkgs.linuxPackages.v4l2loopback
  ];

  security.polkit.enable = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Timezone setup to fix windows time bug thing
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "kime";

  # Autodetect usb shit
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # picom
  services.picom.enable = true;

  # X11
  services.xserver = {
    enable = true;

    xkb.layout = "us";
    xkb.variant = "";

    desktopManager = {
      xterm.enable = false;
    };

    displayManager.setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-0 --mode 1920x1080 --rate 240 --pos 0x0 --rotate left --output DP-2 --primary --mode 1920x1080 --pos 1080x487 --rotate normal";

    windowManager.i3.enable = true;
  };

  # Audio setup
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alex";
    extraGroups = [ "networkmanager" "wheel" "overpass" ];
    packages = with pkgs; [];
  };

  # Fish shell
  programs.fish.enable = true;
  users.users.alex.shell = pkgs.fish;

  # allow myself to trusted users
  nix.settings.trusted-users = ["root" "alex"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Experimental shit
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow dynamic linked executables (for vscode)
  # programs.nix-ld.enable = true;
  # programs.nix-ld.package = pkgs.nix-ld-rs;

  # thunarr
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [ thunar-volman ];
  services.tumbler.enable = true;

  # steam
  programs.steam = {
    enable = true;
  };

  # enable ssh agent
  programs.ssh.startAgent = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    google-chrome
    xclip
    maim
    git
    unzip
    dunst
    zlib
    sbctl
    ripgrep

    expat
    osmctools
    overpass-api

    koboldcpp
    cudaPackages.libcublas
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cccl
  ];

  # Enable CUDA and set architecture for RTX 3080
  nixpkgs.config.cudaSupport = true;
  hardware.nvidia.open = true;

  # Nvidia setup
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];


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
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 5001 5173 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
