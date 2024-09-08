{ config, lib, ... }:

let
  ws1 = "1:󰈹";
  ws2 = "2:󰨞";
  ws3 = "3:";
  ws4 = "4";
  ws5 = "5";
  ws6 = "6";
  ws7 = "7";
  ws8 = "8";
  ws9 = "9:";
  ws10 = "10:";
in
{
  # i3 settings
  xsession.windowManager.i3.enable = true;
  xsession.windowManager.i3.config = 
  {
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

      # Workspaces
      "${modifier}+1" = "workspace number ${ws1}";
      "${modifier}+2" = "workspace number ${ws2}";
      "${modifier}+3" = "workspace number ${ws3}";
      "${modifier}+4" = "workspace number ${ws4}";
      "${modifier}+5" = "workspace number ${ws5}";
      "${modifier}+6" = "workspace number ${ws6}";
      "${modifier}+7" = "workspace number ${ws7}";
      "${modifier}+8" = "workspace number ${ws8}";
      "${modifier}+9" = "workspace number ${ws9}";
      "${modifier}+0" = "workspace number ${ws10}";

      # Move between workspaces
      "${modifier}+Shift+1" = "move container to workspace number ${ws1}";
      "${modifier}+Shift+2" = "move container to workspace number ${ws2}";
      "${modifier}+Shift+3" = "move container to workspace number ${ws3}";
      "${modifier}+Shift+4" = "move container to workspace number ${ws4}";
      "${modifier}+Shift+5" = "move container to workspace number ${ws5}";
      "${modifier}+Shift+6" = "move container to workspace number ${ws6}";
      "${modifier}+Shift+7" = "move container to workspace number ${ws7}";
      "${modifier}+Shift+8" = "move container to workspace number ${ws8}";
      "${modifier}+Shift+9" = "move container to workspace number ${ws9}";
      "${modifier}+Shift+0" = "move container to workspace number ${ws10}";

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

      # screenshot
      "${modifier}+Shift+s" = "exec \"maim -s | xclip -selection clipboard -t image/png -i\"";
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
      { workspace = "${ws1}"; output = "primary"; } 
    ];

    startup = [
      { command = "systemctl --user restart polybar"; always = true; notification = false; }
    ];
  };
  xsession.windowManager.i3.extraConfig = ''
    hide_edge_borders both
    focus_on_window_activation focus
    for_window [class="firefox"] move workspace ${ws1}
    for_window [class="Code"] move workspace ${ws2}
    for_window [class="kitty"] move workspace ${ws3}
    for_window [class="discord"] move workspace ${ws9}
    for_window [class="Spotify"] move workspace ${ws10}
  '';
}
