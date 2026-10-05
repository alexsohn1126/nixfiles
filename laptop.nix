{ config, pkgs, lib, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.dpi = 160;

  # just for when hosting something like MC server
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    IdleAction = "ignore";
    HandlePowerKey = "ignore";
    HandleSuspendKey = "ignore";
  };
  environment.systemPackages = with pkgs; [
    jdk
  ];
  networking.firewall.allowedTCPPorts = [ 25565 ];
}
