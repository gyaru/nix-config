{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    alejandra
    atool
    curl
    fd
    file
    home-manager
    jq
    man-pages
    man-pages-posix
    nano
    nix-output-monitor
    p7zip
    ripgrep
    unzip
    wget
  ];
}
