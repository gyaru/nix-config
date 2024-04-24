{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../applications/firefox
    ../applications/wezterm.nix
  ];

  home = {
    homeDirectory = lib.mkForce "/Users/bun";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    raycast
    nnn
    comma

    zip
    xz
    unzip
    p7zip

    ripgrep
    jq
    yq-go
    fzf
    aria2
    socat
    nmap
    cowsay
    file
    which
    tree
    gnused
    nixfmt
    nil
    gnutar
    gawk
    zstd
    gnupg
    glow
    alejandra
    nom
  ];

  programs = {
    # modern vim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    vscode = {
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

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      # extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
    };
    eza = {
      enable = true;
      git = true;
      icons = true;
    };
    skim = {
      enable = true;
      enableBashIntegration = true;
    };
  };
}
