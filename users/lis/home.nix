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
    ./applications/firefox
    ./applications/ags.nix
    ./applications/spicetify.nix
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
        ]
        ++ lib.forEach ["keyrings" "direnv" "wallpapers" "TelegramDesktop"] (
          x: ".local/share/${x}"
        )
        ++ lib.forEach ["ArmCord" "spotify"] (
          x: ".config/${x}"
        )
        ++ lib.forEach ["tealdeer" "nix" "starship" "nix-index" "mozilla"] (
          x: ".cache/${x}"
        );
      files = [
        ".zsh_history" # zsh history
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
      imv
      socat
      runelite
      armcord
      tealdeer
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
      GLFW_IM_MODULE = "ibus";
    };
  };

  # home-manager
  programs.home-manager.enable = true;

  # git
  programs.git.enable = true;

  # starship
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  # direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # fzf
  programs.fzf.enable = true;

  # zsh
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

  gtk = {
    theme.package = [pkgs.adw-gtk3];
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

  systemd.user.services.fcitx5-daemon = {
    Unit = {
      Description = "Fcitx5 input method editor";
      PartOf = ["graphical-session.target"];
    };
    Service.ExecStart = "${pkgs.fcitx5}/bin/fcitx5";
    Install.WantedBy = ["graphical-session.target"];
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
