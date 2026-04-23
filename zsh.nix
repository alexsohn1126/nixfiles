{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Re-source the nix-daemon profile script. macOS updates periodically
    # overwrite /etc/zshrc and strip the block the Nix installer put there,
    # leaving `nix` off PATH until you restore it by hand.
    envExtra = ''
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';

    initContent = ''
      # Source company-managed zshrc
      [[ -f ~/.zshrc ]] && source ~/.zshrc
    '';
  };
}
