{ config, lib, ... }:

{
  # i3 settings
  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.config = {
    modifier = "Mod4";
    terminal = "kitty";
    
    # for polybar
    bars = [];

    keybindings = 
    let
      modifier = config.xsession.windowManager.i3.config.modifier;
    in lib.mkOptionDefault {
      # Audio control
      "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
      "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";

      # Use vim bindings
      "${modifier}+b" = "split h";
      "${modifier}+h" = "focus left";
      "${modifier}+j" = "focus down";
      "${modifier}+k" = "focus up";
      "${modifier}+l" = "focus right";
      "${modifier}+Shift+h" = "move left";
      "${modifier}+Shift+j" = "move down";
      "${modifier}+Shift+k" = "move up";
      "${modifier}+Shift+l" = "move right";
      "${modifier}+Ctrl+h" = "move workspace to output left";
      "${modifier}+Ctrl+l" = "move workspace to output right";
    };
    colors =
    let
      border-color	 = "#232634";
      active-bg-color 	 = "#85c1dc";
      active-text-color  = "#303446";
      inactive-bg-color  = "#2f343f";
      inactive-text-color= "#676E7D";
      urgent-bg-color    = "#E53935";
      text-color         = "#c6d0f5";
      indicator 	 = "#00ff00";
    in {
      focused = {
        background 	= active-bg-color;
	border 		= active-bg-color;
	text 		= active-text-color;
	indicator 	= active-bg-color;
	childBorder 	= active-bg-color;
      };
      unfocused = {
        background 	= inactive-bg-color;
	border 		= inactive-bg-color;
	text 		= inactive-text-color;
	indicator 	= inactive-bg-color;
	childBorder 	= inactive-bg-color;
      };
      focusedInactive = {
        background 	= inactive-bg-color;
	border 		= inactive-bg-color;
	text 		= inactive-text-color;
	indicator 	= inactive-bg-color;
	childBorder 	= inactive-bg-color;
      };
      urgent = {
        background 	= urgent-bg-color;
	border 		= urgent-bg-color;
	text 		= text-color;
	indicator 	= urgent-bg-color;
	childBorder 	= urgent-bg-color;
      };
    };

    # set workspace 1 to appear on primary screen always!
    workspaceOutputAssign = [
      { workspace = "1"; output = "primary"; } 
    ];

    startup = [
      { command = "systemctl --user restart polybar"; always = true; notification = false; }
    ];
  };
}
