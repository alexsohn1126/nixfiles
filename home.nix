{ config, lib, pkgs, ... }:

{
  imports = [
    ./polybar.nix
    ./i3.nix
    ./fish.nix
    ./starship.nix
  ];
  home.username = "alex";
  home.homeDirectory = "/home/alex";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = [
    # Only install JetBrainsMono font
    pkgs.nerd-fonts.jetbrains-mono

    # Korean font
    pkgs.noto-fonts-cjk-sans
    pkgs.spotify
    pkgs.discord
    pkgs.devenv
    pkgs.pavucontrol
    pkgs.droidcam
    pkgs.obs-studio
    pkgs.bruno
    pkgs.openblas
    pkgs.pixelorama
    pkgs.tree
    pkgs.fd
    pkgs.vlc
    pkgs.vencord
    pkgs._1password
    pkgs._1password-gui
    pkgs.qbittorrent
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alex/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # enable font config
  fonts.fontconfig.enable = true;

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  
  # kitty
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Frappe";
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
    font = {
      name = "JetBrainsMonoNL";
      size = 12;
    };
  };

  # neovim
  programs.neovim.enable = true;

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };

  # Enable Git
  programs.git = {
    enable = true;
    userName = "Alex Sohn";
    userEmail = "alexsohn1126@gmail.com";
    extraConfig = {
      core = { editor = "nvim"; };
    };
  };

  # Overlay
  nixpkgs.overlays = [(import ./spotx.nix)];
  
  home.pointerCursor.x11.enable = true;
  home.pointerCursor.name = "Bibata-Original-Ice";
  home.pointerCursor.size = 24;
  home.pointerCursor.package = pkgs.bibata-cursors;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
