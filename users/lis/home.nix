{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    (inputs.impermanence + "/home-manager.nix")
    ./applications/hyprland.nix
    ./applications/vscode.nix
    ./applications/anyrun.nix
    ./applications/wezterm.nix
    ./applications/firefox.nix
    ./applications/eww
  ];

  home = {
    username = "lis";
    homeDirectory = "/home/lis";
    packages = with pkgs; [
      telegram-desktop
      bitwarden
      grim
      slurp
      btop
      spotify
      mpv
      eww-wayland
      swaybg
      wlogout
      playerctl
      discord-canary
      imv
      river
    ];

    sessionPath = [];

    sessionVariables = {
      BROWSER = "firefox";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XCURSOR_SIZE = "16";
      XCURSOR_THEME = "Adwaita";
      NIXOS_OZONE_WL = "1";
      MOZ_USE_XINPUT2 = "1";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };

  # enable home-manager
  programs.home-manager.enable = true;
  # enable git
  programs.git.enable = true;

  # starship
  programs.starship = {
    enable = true;
    settings = {add_newline = false;};
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {enable = true;};

  programs.zsh = {
    enable = true;
    initExtra = "";
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
    ];
  };

  home.persistence."/persist/home/lis" = {
    directories = [
      "downloads"
      "pictures"
      "projects"
      "documents"
      "videos"
      ".gnupg"
      ".ssh"
      ".mozilla" # firefox TODO: make a more specific one?
      ".cache" # TODO: check if we actually want this, maybe target specific directories instead
      ".local/share/keyrings"
      ".local/share/direnv"
      ".local/share/wallpapers"
      ".local/share/TelegramDesktop/tdata" # telegram
      ".config/discordcanary" # discord
    ];
    files = [
      # ".local/share/TelegramDesktop/tdata/settingss" # telegram settings, TODO: use folder instead?
    ];
    allowOther = true;
  };

  # xdg defaults
  xdg = {
    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music"; #
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
    };
  };

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
