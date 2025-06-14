{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  cursorTheme = {
    name = "BreezeX-RosePineDawn-Linux";
    size = 24;
    package = pkgs.rose-pine-cursor;
  };
in {
  imports = [
    (inputs.impermanence + "/home-manager.nix")
    ./applications/hyprland.nix
    ./applications/vscode.nix
    ./applications/anyrun.nix
    ./applications/firefox
    ./applications/ags
    ./applications/kitty.nix
  ];

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style.name = "adwaita";
    style.package = pkgs.adwaita-qt;
  };

  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
    theme.package = pkgs.adw-gtk3;
    cursorTheme = {
      inherit (cursorTheme) package name size;
    };
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
          ".vscode"
          ".var"
        ]
        ++ lib.forEach ["keyrings" "direnv" "wallpapers" "TelegramDesktop" "flatpak"] (
          x: ".local/share/${x}"
        )
        ++ lib.forEach ["spotify" "vesktop"] (
          x: ".config/${x}"
        )
        ++ lib.forEach ["tealdeer" "nix" "starship" "nix-index" "flatpak"] (
          x: ".cache/${x}"
        );
      files = [
        ".zsh_history"
      ];
      allowOther = true;
    };

    packages = with pkgs; [
      btop
      claude-code
      code-cursor
      eza
      flatpak
      ghostty
      grim
      hyprpicker
      hyprprop
      imv
      mpv
      nil
      obs-studio
      playerctl
      runelite
      slurp
      socat
      spotify
      strace
      swaybg
      tealdeer
      telegram-desktop
      vesktop
      waybar
      wl-clipboard
      wlogout
      xclip
      xdg-utils
    ];

    sessionPath = [];

    sessionVariables = {
      RUSTUP_HOME = "${config.home.homeDirectory}/.local/share/rustup";
      XCURSOR_SIZE = cursorTheme.size;
      XCURSOR_THEME = cursorTheme.name;
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    fzf.enable = true;
    zsh = {
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
      envExtra = ''
        if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
          dbus-run-session Hyprland
        fi
      '';
    };
  };

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "23.11";
}
