pkgs: let
  packages = [
    "mplus-fonts"
    "balsamiqsans"
    "lucide-icons"
  ];
in
  builtins.listToAttrs (map (name: {
      inherit name;
      value = pkgs.callPackage (./. + "/${name}") {};
    })
    packages)
