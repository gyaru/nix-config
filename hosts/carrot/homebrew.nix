{...}: {
  homebrew = {
    enable = true;
    global = {autoUpdate = false;};
    onActivation = {
      cleanup = "zap";
      autoUpdate = false;
      upgrade = false;
    };
    casks = [
      "nikitabobko/tap/aerospace"
    ];
    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/services"
    ];
  };
}
