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
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "'M PLUS 1 Code', 'Maple Mono NF', 'Noto Color Emoji', 'monospace', monospace";
      "workbench.colorTheme" = "Rosé Pine Dawn";
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.productIconTheme" = "material-product-icons";
      "window.titleBarStyle" = "custom";
      "[nix]" = {"editor.defaultFormatter" = "kamadorueda.alejandra";};
    };
  };
}
