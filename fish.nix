{ config, lib, pkgs, ... }:

{
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    direnv hook fish | source
  '';
}
