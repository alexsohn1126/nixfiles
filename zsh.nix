{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Source company-managed zshrc
      [[ -f ~/.zshrc ]] && source ~/.zshrc
    '';
  };
}
