{ pkgs, lib, ... }:

{
  imports = [
    ./zsh.nix
    ./starship.nix
  ];
  home.username = "alexsohn";
  home.homeDirectory = "/Users/alexsohn";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = [
    pkgs.fd
    pkgs.tree
    pkgs.nil

    pkgs.nerd-fonts.jetbrains-mono
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

  # Create macOS aliases in ~/Applications so Spotlight can find Nix apps
  # (macOS doesn't index symlinks, but it does index aliases)
  home.activation.aliasNixApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    app_folder="$HOME/Applications/Nix Apps"
    mkdir -p "$app_folder"
    # Remove old aliases
    find "$app_folder" -maxdepth 1 -type f -name "*.app" -delete 2>/dev/null || true
    # Create macOS aliases for each .app in the HM profile
    for app in "$HOME"/.nix-profile/Applications/*.app; do
      [ -e "$app" ] || continue
      app_name="$(basename "$app")"
      real_app="$(readlink -f "$app")"
      ${pkgs.writeShellScript "mkalias" ''
        /usr/bin/osascript -e "
          tell application \"Finder\"
            set theApp to POSIX file \"$1\" as alias
            make new alias file at POSIX file \"$2\" to theApp with properties {name:\"$3\"}
          end tell
        "
      ''} "$real_app" "$app_folder" "$app_name"
    done
  '';

  # Copy Nerd Fonts to ~/Library/Fonts so macOS can discover them
  # (macOS CoreText doesn't follow symlinks, so we must copy real files)
  home.activation.copyNerdFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fontsDir="$HOME/Library/Fonts/NerdFonts"
    mkdir -p "$fontsDir"
    chmod -R u+w "$fontsDir" 2>/dev/null || true
    ${pkgs.rsync}/bin/rsync -a --delete \
      "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/" \
      "$fontsDir/"
    chmod -R u+w "$fontsDir"
  '';

  # aerospace
  programs.aerospace = {
    enable = true;
    settings = {
      accordion-padding = 10;

      mode.main.binding = {
        # focus (alt + h/j/k/l)
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        # move window (alt + shift + h/j/k/l)
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        # switch workspace (alt + 0-9)
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";
        alt-0 = "workspace 10";

        # move window to workspace (alt + shift + 0-9)
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 10";

        # layout
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";
        alt-f = "fullscreen";
        alt-shift-space = "layout floating tiling";

        # resize
        alt-minus = "resize smart -50";
        alt-equal = "resize smart +50";

        # move workspace to monitor
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # service mode
        alt-shift-semicolon = "mode service";
      };

      mode.service.binding = {
        esc = ["reload-config" "mode main"];
        r = ["flatten-workspace-tree" "mode main"];
        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];
      };
    };
  };

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ghostty (installed via Homebrew/dmg on macOS, config managed here)
  programs.ghostty = {
    enable = true;
    installBatSyntax = false;
    package = null;
    settings = {
      theme = "catppuccin-frappe";
      font-family = "JetBrainsMonoNL";
      font-size = 16;
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
    settings = {
      user = {
        name = "Alex Sohn";
        email = "alexsohn1126@gmail.com";
      };
      core.editor = "nvim";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
