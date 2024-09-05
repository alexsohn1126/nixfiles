{ config, lib, pkgs, ... }:

{
  services.polybar = {
    enable = true;

    # MAKE SURE & AT THE END! (otherwise it restarts every 90 s)
    script = "polybar -q -r top &";
    package = pkgs.polybar.override {
      alsaSupport = true;
      pulseSupport = true;
      i3Support = true;
    };
    config = 
    let 
      background = "#282A2E";
      background-alt = "#373B41";
      foreground = "#C5C8C6";
      primary = "#F0C674";
      secondary = "#8ABEB7";
      alert = "#A54242";
      disabled = "#707880";
    in {
      "settings" = {
        screencahnge-reload = true;
	pseudo-transparency = true;
      };

      "colors" = { 
        inherit background background-alt foreground primary secondary alert disabled;
      };

      "bar/top" = {
        inherit background foreground;
        width = "100%";
	height = "24pt";
	radius = 6;
	
	line-size = "3pt";
	border-size = "4pt";
	border-color = "#000000";

	padding-left = 0;
	padding-right = 1;

	module-margin = 1;

	separator = "|";
	separator-foreground = disabled;

	font-0 = "JetBrainsMono;2";

	modules-left = "xworkspaces xwindow";
	modules-right = "volume xkeyboard systray date";

	cursor-click = "pointer";
	cursor-scroll = "ns-resize";

	enable-ipc = true;
      };

      "module/systray" = {
        type = "internal/tray";

	format-margin = "8pt";
	tray-spacing = "16pt";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

	label-active = "%name%";
	label-active-background = background-alt;
	label-active-underline = primary;
	label-active-padding = 1;

	label-occupied = "%name%";
	label-occupied-padding = 1;

	label-urgent = "%name%";
	label-urgent-background = disabled;
	label-urgent-padding = 1;

	label-empty = "%name%";
	label-empty-foreground = disabled;
	label-empty-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
	label = "%title:0:60:...%";
      };

      "module/volume" = {
        type = "internal/pulseaudio";
      };

      "module/volume-old" = 
      let
        grep-muted =
	'' wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "\\[MUTED\\]" '';
	echo-current-volume =
	'' wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oP "\\.[0-9]+" | grep -oP "[0-9]+" '';
	echo-output =
	'' if ${grep-muted}; then echo "MUTED VOL $(${echo-current-volume})"; else echo "VOL $(${echo-current-volume})"; fi ''; 
      in {
        type = "custom/script";
	label = "%output%";
	label-font = 2;
	interval = "2.0";
	exec = "${echo-output}";
	click-left = "wpctl set-mute @DEFAULT_AUDIO_SINK@; ${echo-output} &";
	scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+; ${echo-output} &";
	scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; ${echo-output} &";
      };

      "module/xkeyboard" = {
        type = "internal/xkeyboard";
	blacklist-0 = "num lock";

	label-layout = "%layout%";
	label-layout-foreground = primary;

	label-indicator-padding = 2;
	label-indicator-margin = 1;
	label-indicator-foreground = background;
	label-indicator-background = secondary;
      };

      "module/date" = {
        type = "internal/date";
	interval = 1;

	date = "%H:%M:%S";
	date-alt = "%Y-%m-%d %H:%M:%S";

	label = "%date%";
	label-foreground = primary;
      };

    };
  };
}
