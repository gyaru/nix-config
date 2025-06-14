{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./applications/firefox
    ./applications/kitty.nix
    ./applications/vscode.nix
    ./applications/aerospace.nix
  ];

  home = {
    homeDirectory = lib.mkForce "/Users/bun";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    alejandra
    aria2
    comma
    cowsay
    file
    fzf
    gawk
    glow
    gnupg
    gnused
    gnutar
    jq
    nil
    nix-output-monitor
    nmap
    nnn
    p7zip
    raycast
    ripgrep
    socat
    tree
    unzip
    which
    xz
    yq-go
    zip
    zstd
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
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
