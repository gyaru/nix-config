{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    configDir = builtins.toString ./.;
    extraPackages = with pkgs;
    with inputs.ags.packages.${pkgs.system}; [
      libsoup_3
      apps
      auth
      bluetooth
      hyprland
      mpris
      notifd
      tray
      wireplumber
    ];
  };
  # TODO: add systemd user service for AGS
}
