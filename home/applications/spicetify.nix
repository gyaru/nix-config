{
  inputs,
  pkgs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [inputs.spicetify-nix.homeManagerModules.default];
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Ziro;
    colorScheme = "rose-pine-dawn";
    enabledExtensions = with spicePkgs.extensions; [
      fullAlbumDate
      powerBar
      songStats
    ];
  };
}
