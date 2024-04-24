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
      vesktop
      tealdeer
    ];

    sessionPath = [];

    sessionVariables = {
      BROWSER = "firefox";
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XCURSOR_SIZE = "16";
      XCURSOR_THEME = "Simp1e-Gruvbox-Dark";
      NIXOS_OZONE_WL = "1";
      MOZ_USE_XINPUT2 = "1";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
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

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
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

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-chinese-addons
    ];
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
