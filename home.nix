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
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # Korean font
    pkgs.noto-fonts-cjk
    pkgs.spotify
    pkgs.discord
    pkgs.devenv
    pkgs.pavucontrol
    pkgs.droidcam

    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
    theme = "Catppuccin-Frappe";
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
    };
    font = {
      name = "JetBrainsMono";
      size = 12;
    };
  };

  # vscode
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      catppuccin.catppuccin-vsc
      naumovs.color-highlight
      bradlc.vscode-tailwindcss
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Frappé";
      "catppuccin.accentColor" = "sapphire";
      "editor.fontFamily" = "'JetBrainsMonoNL NFM', 'monospace', monospace";
      "window.titleBarStyle" = "custom";
    };
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
