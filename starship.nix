{ config, lib, pkgs, ... }:

{
  programs.starship.enable = true;
  # Transience allows starship to delete previous outputs
  programs.starship.enableTransience = true;

  programs.starship.settings = {
    directory.fish_style_pwd_dir_length = 1;

    username = {
      show_always = true;
      style_user = "bg:red fg:crust";
      style_root = "bg:red fg:crust";
      format = "[$user ]($style)";
    };

    os = {
      disabled = false;
      symbols.NixOS = " ";
      style = "bg:red fg:crust";
    };

    directory = {
      style = "fg:crust bg:peach";
      format = "[ $path ]($style)";
      truncation_length = 3;
      substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = "󰇚 ";
        "Music" = "󰝚 ";
        "Pictures" = " ";
        "Projects" = "󰲋 ";
      };
    };

    git_branch = {
      symbol = "";
      style = "bg:yellow";
      format = "[[ $symbol $branch ](fg:crust bg:yellow)]($style)";
    };

    git_status = {
      style = "bg:yellow";
      format = "[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)";
    };

    nodejs = {
      symbol = "";
      style = "bg:green";
      format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
    };

    python = {
      symbol = "";
      style = "bg:green";
      format = "[[ $symbol( $version) ](fg:crust bg:green)]($style)";
    };

    time = {
      disabled = false;
      time_format = "%R";
      style = "bg:blue";
      format = "[[  $time ](fg:crust bg:blue)]($style)";
    };

    character = {
      disabled = false;
      success_symbol = "[](bold fg:green)";
      error_symbol = "[](bold fg:red)";
    };

    # Catppuccin Frappe Colors
    palette = "catppuccin_frappe";
    palettes.catppuccin_frappe = {
      rosewater = "#f2d5cf";
      flamingo = "#eebebe";
      pink = "#f4b8e4";
      mauve = "#ca9ee6";
      red = "#e78284";
      maroon = "#ea999c";
      peach = "#ef9f76";
      yellow = "#e5c890";
      green = "#a6d189";
      teal = "#81c8be";
      sky = "#99d1db";
      sapphire = "#85c1dc";
      blue = "#8caaee";
      lavender = "#babbf1";
      text = "#c6d0f5";
      subtext1 = "#b5bfe2";
      subtext0 = "#a5adce";
      overlay2 = "#949cbb";
      overlay1 = "#838ba7";
      overlay0 = "#737994";
      surface2 = "#626880";
      surface1 = "#51576d";
      surface0 = "#414559";
      base = "#303446";
      mantle = "#292c3c";
      crust = "#232634";
    };

    format = lib.concatStrings [
      "[](red)"
      "$username"
      "$os"
      "[](bg:peach fg:red)"
      "$directory"
      "[](fg:peach bg:yellow)"
      "$git_branch"
      "$git_status"
      "[](fg:yellow bg:green)"
      "$nodejs"
      "$python"
      "[](fg:green bg:teal)"
      "[](fg:teal bg:blue)"
      "$time"
      "[ ](fg:blue)"
      "$line_break"
      "$character"
    ];
  };
}
