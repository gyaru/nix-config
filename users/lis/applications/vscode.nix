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
      bbenoist.nix
      kamadorueda.alejandra
      eamodio.gitlens
      pkief.material-product-icons
      pkief.material-icon-theme
    ];
    userSettings = {
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'Maple Mono NF', 'monospace', monospace";
      "workbench.colorTheme" = "Rosé Pine Dawn";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.productIconTheme" = "material-product-icons";
      "window.titleBarStyle" = "custom";
      "[nix]" = {"editor.defaultFormatter" = "kamadorueda.alejandra";};
    };
  };
}
