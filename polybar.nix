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
      foreground = "#C6D0F5";
      primary = "#85C1DC";
      secondary = "#8ABEB7";
      alert = "#A54242";
      disabled = "#707880";
    in {
      "settings" = {
        screenchange-reload = true;
	pseudo-transparency = true;
      };

      "colors" = { 
        inherit background background-alt foreground primary secondary alert disabled;
      };

      "bar/top" = {
        inherit background foreground;
        width = "100%";
	height = "18pt";
	
	line-size = "3pt";
	border-size = "4pt";
	border-color = background;

	padding-left = 0;
	padding-right = 1;

	module-margin = 1;

	separator = "|";
	separator-foreground = disabled;

	font-0 = "JetBrainsMonoNL NFM;2";
	font-1 = "Noto Sans Mono CJK KR;2";

	modules-left = "i3";
	modules-center = "xwindow";
	modules-right = "volume xkeyboard systray date";

	cursor-click = "pointer";
	cursor-scroll = "ns-resize";

	enable-ipc = true;
      };

      "module/systray" = {
        type = "internal/tray";

	format-margin = "0pt";
	tray-spacing = "8pt";
      };

      "module/i3" = {
        type = "internal/i3";

	strip-wsnumbers = true;
	index-sort = true;

	label-mode-padding = "4pt";

	label-focused = "%name%";
	label-focused-background = background-alt;
	label-focused-underline = primary;
	label-focused-padding = 1;

        label-unfocused = "%name%";
	label-unfocused-padding = 1;

	label-visible = "%name%";
	label-visible-padding = 1;

	label-urgent = "%name%";
	label-urgent-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
	label = "%title:0:60:...%";
      };

      "module/volume" = {
        type = "internal/pulseaudio";
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
