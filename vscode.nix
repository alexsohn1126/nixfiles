{ config, lib, pkgs, ... }:

{
  # vscode
  programs.vscode.enable = true;
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      bradlc.vscode-tailwindcss
      esbenp.prettier-vscode
      naumovs.color-highlight
      vscodevim.vim
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Frappé";
      "workbench.sideBar.location" = "right";

      "catppuccin.accentColor" = "sapphire";

      "window.titleBarStyle" = "custom";

      "editor.formatOnSave" = true;
      "editor.fontFamily" = "'JetBrainsMonoNL NFM', 'monospace', monospace";
      "editor.lineNumbers" = "relative";
      "editor.minimap.enabled" = false;
      "editor.quickSuggestions" = {
        "strings" = true;
      };

      "[javascript]" = {
        "editor.tabSize" = 2;
	"editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascriptreact]" = {
        "editor.tabSize" = 2;
	"editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescript]" = {
        "editor.tabSize" = 2;
	"editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[typescriptreact]" = {
        "editor.tabSize" = 2;
	"editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
    };
    keybindings = [
      { 
        "key" = "ctrl+tab";
        "command" = "workbench.action.nextEditor";
      }
      { 
        "key" = "ctrl+shift+tab";
        "command" = "workbench.action.previousEditor";
      }
      { 
        "key" = "ctrl+n";
        "command" = "explorer.newFile";
	"when" = "explorerViewletFocus";
      }
    ];
  };

}
