{ inputs', lib, pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      mvllow.rose-pine
      bbenoist.nix
      brettm12345.nixfmt-vscode
      eamodio.gitlens
      pkief.material-product-icons
      pkief.material-icon-theme
    ];
    #TODO: fix this some day lol
    /* userSettings = {
          "editor.fontSize" = 14;
          "editor.fontLigatures" = true;
          "editor.fontFamily" = "'Maple Mono NF', 'monospace', monospace";
          "workbench.colorTheme" = "Rosé Pine Dawn";
          "workbench.iconTheme" = "material-icon-theme";
          "workbench.productIconTheme" = "material-product-icons";
          "window.titleBarStyle" = "custom";
          "workbench.iconTheme" = "eq-material-theme-icons-ocean";
          "[nix]" = {
            "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
          };
        };
    */
  };
}
