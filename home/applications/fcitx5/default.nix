{pkgs, ...}: {
  home.sessionVariables = {
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-chinese-addons
    ];
  };
  xdg.configFile = {
    "fcitx5/config".source = ./config;
    "fcitx5/profile".source = ./profile;
    "fcitx5/conf/classicui.conf".source = ./classicui.conf;
  };
}
