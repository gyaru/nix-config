{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./applications/firefox
    ./applications/kitty.nix
    ./applications/vscode.nix
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
