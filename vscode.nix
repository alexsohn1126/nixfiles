{ config, lib, pkgs, ... }:

{
  # vscode
#      rooveterinaryinc.roo-cline
  programs.vscode.enable = true;
  programs.vscode.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      bradlc.vscode-tailwindcss
      catppuccin.catppuccin-vsc
      esbenp.prettier-vscode
      golang.go
      naumovs.color-highlight
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
    userSettings = {
      "workbench.colorTheme" = "Catppuccin Frappé";
      "workbench.sideBar.location" = "right";

#      "catppuccin.accentColor" = "sapphire";

      "window.titleBarStyle" = "custom";

      "explorer.sortOrder" = "type";
      "editor.formatOnSave" = true;
      "editor.fontFamily" = "'JetBrainsMonoNL NFM', 'monospace', monospace";
      "editor.lineNumbers" = "relative";
      "editor.minimap.enabled" = false;
      "editor.quickSuggestions" = {
        "strings" = true;
      };
      "editor.rulers" = [80];

      "markdown.extension.list.indentationSize" = "inherit";
      "markdown.editor.filePaste.enabled" = "always";

      "vim.useSystemClipboard" = true;

      "[json]" = {
        "editor.tabSize" = 2;
	"editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascript]" = {
        "editor.tabSize" = 2;
	"editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[javascriptreact]" = {
        "editor.tabSize" = 2;
	"editor.defaultFormatter" = "esbenp.prettier-vscode";
      };
      "[markdown]" = {
        "editor.tabSize" = 2;
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
