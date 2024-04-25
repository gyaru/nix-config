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
    ../applications/hyprland.nix
    ../applications/vscode.nix
    ../applications/anyrun.nix
    ../applications/wezterm.nix
    ../applications/firefox
    ../applications/ags.nix
    ../applications/spicetify.nix
    ../applications/fcitx5
  ];

  home = {
    username = "lis";
    homeDirectory = "/home/lis";

    # impermanence is cool or something
    persistence."/persist/home/lis" = {
      directories =
        [
          "downloads"
          "pictures"
          "projects"
          "documents"
          "videos"
          ".gnupg"
          ".ssh"
          ".runelite"
          ".vscode"
          ".var"
        ]
        ++ lib.forEach ["keyrings" "direnv" "wallpapers" "TelegramDesktop"] (
          x: ".local/share/${x}"
        )
        ++ lib.forEach ["ArmCord" "spotify" "vesktop"] (
          x: ".config/${x}"
        )
        ++ lib.forEach ["tealdeer" "nix" "starship" "nix-index"] (
          x: ".cache/${x}"
        );
      files = [
        ".zsh_history"
      ];
      allowOther = true;
    };

    packages = with pkgs; [
      telegram-desktop
      bitwarden
      grim
      slurp
      btop
      swaybg
      obs-studio
      mpv
      eza
      nil
      wl-clipboard
      hyprpicker
      wlogout
      flatpak
      playerctl
      xdg-utils
      imv
      socat
      runelite
      vesktop
      tealdeer
      flatpak
    ];

    sessionPath = [];

    sessionVariables = {
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XCURSOR_SIZE = "16";
      XCURSOR_THEME = "Simp1e-Gruvbox-Dark";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fzf.enable = true;
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

  qt = {
    enable = true;
    platformTheme = "gtk3";
    style.name = "adwaita";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    theme.package = pkgs.adw-gtk3;
    cursorTheme.package = pkgs.simp1e-cursors;
    cursorTheme.name = "Simp1e-Gruvbox-Dark"; # TODO: ref previous
    cursorTheme.size = 16;
  };

  xdg = {
    userDirs = {
      enable = true;
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = "${config.home.homeDirectory}/music";
      pictures = "${config.home.homeDirectory}/pictures";
      videos = "${config.home.homeDirectory}/videos";
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
