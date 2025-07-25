{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./homebrew.nix
  ];
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = false;
    };
    package = pkgs.nix;
    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-darwin";
    config = {
      allowUnfree = true;
    };
  };
  services.nix-daemon.enable = true;
  system = {
    defaults = {
      menuExtraClock.Show24Hour = true;

      dock = {
        autohide = true;
        show-recents = true;
      };

      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        QuitMenuItem = true;
        ShowPathbar = true;
        ShowStatusBar = true;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
      };

      CustomUserPreferences = {
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf";
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.spaces" = {
          "spans-displays" = 0;
        };
        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = 0;
          StandardHideDesktopIcons = 0;
          HideDesktop = 0;
          StageManagerHideWidgets = 0;
          StandardHideWidgets = 0;
        };
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        "com.apple.ImageCapture".disableHotPlug = true;
      };

      loginwindow = {
        GuestEnabled = false;
      };
    };
  };

  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh.enable = true;
  environment.shells = [
    pkgs.zsh
  ];

  fonts = {
    # https://github.com/LnL7/nix-darwin/pull/754
    fontDir.enable = true;
    fonts = with pkgs; [
      material-design-icons
      font-awesome
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "FiraCode"
        ];
      })
      noto-fonts
      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (callPackage ../../pkgs/mplus-fonts {})
      (callPackage ../../pkgs/lucide-icons {})
    ];
  };
  networking.hostName = "carrot";
  networking.computerName = "carrot";
  system.defaults.smb.NetBIOSName = "carrot";
}
