{
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      mvllow.rose-pine
      eamodio.gitlens
      pkief.material-product-icons
      pkief.material-icon-theme
      jnoortheen.nix-ide
    ];
    userSettings = {
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.fontFamily" = "'M PLUS 1 Code', 'Maple Mono NF', 'Noto Color Emoji', 'monospace', monospace";
      "workbench.colorTheme" = "Rosé Pine Dawn";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";
      "workbench.productIconTheme" = "material-product-icons";
      "git.confirmSync" = false;
      "git.autofetch" = true;
      "window.titleBarStyle" = "custom";
      "[nix]" = {"editor.defaultFormatter" = "jnoortheen.nix-ide";};
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["alejandra"];
          };
        };
      };
    };
  };
}
