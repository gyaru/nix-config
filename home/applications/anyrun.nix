{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.anyrun.homeManagerModules.default];
  programs.anyrun = {
    enable = true;

    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        translate
      ];
      hidePluginInfo = true;
      layer = "overlay";
      closeOnClick = true;
      y.absolute = 150;
    };

    extraCss = ''
      * {
        transition: unset;
        border-radius: unset;
        font-family: 'BalsamiqSans', sans-serif;
        font-weight: normal;
        font-size: 21px;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      #match:selected {
        color: #FBF1E5;
        background: #d7827e;
      }

      #list {
        border-top: 3px solid #d7827e;
      }

      #entry {
        border: unset;
        box-shadow: unset;
      }

      #plugin {
        border: unset;
      }

      box#main {
        background: #faf4ed;
        border: 3px solid #d7827e;
      }
    '';
  };
}
