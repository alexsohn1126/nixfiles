{ config, pkgs, lib, ... }:

let
  sources = import ./nix/sources.nix;
  lanzaboote = import sources.lanzaboote;
  overpass-api = pkgs.callPackage ./overpass/overpass.nix {};
in
{
  imports = [
    #./overpass/overpass-backend.nix
    lanzaboote.nixosModules.lanzaboote
  ];

  # Droidcam setup
  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModulePackages = [
    pkgs.linuxPackages.v4l2loopback
  ];
  security.polkit.enable = true;

  # Dual boot / Secure Boot
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  # Nvidia & CUDA
  nixpkgs.config.cudaSupport = true;
  hardware.nvidia.open = true;
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # desktop specific xrandr setup
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output DP-0 --mode 1920x1080 --rate 240 --pos 0x0 --rotate left \
      --output DP-2 --primary --mode 1920x1080 --pos 1080x487 --rotate normal
  '';

  environment.systemPackages = with pkgs; [
    koboldcpp
    cudaPackages.libcublas
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cuda_cccl
    sbctl

    expat
    osmctools
    overpass-api
  ];
}
