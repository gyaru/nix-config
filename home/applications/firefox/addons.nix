{
  pkgs,
  lib,
  ...
}: let
  buildFirefoxXpiAddon = lib.makeOverridable ({
    stdenv ? pkgs.stdenv,
    fetchurl ? pkgs.fetchurl,
    pname,
    version,
    addonId,
    url,
    sha256,
    meta ? {},
    ...
  }:
    stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = fetchurl {inherit url sha256;};

      preferLocalBuild = true;
      allowSubstitutes = true;

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    });
in {
  "seventv-nightly" = buildFirefoxXpiAddon {
    pname = "7TV Nightly";
    version = "3.0.10.1000";
    addonId = "moz-addon@7tv.app";
    url = "https://extension.7tv.gg/v3.0.10.1000/ext.xpi";
    sha256 = "dZyjFayvnLebSZHjMTTQFjcsxxpmc1aL5q17mLF3kG8=";
    meta = with lib; {
      homepage = "https://7tv.app/";
      description = "Improve your viewing experience on Twitch & YouTube with new features, emotes, vanity and performance.";
      license = licenses.asl20;
      mozPermissions = ["*://*.twitch.tv/*" "*://*.youtube.com/*" "*://*.kick.com/*" "*://*.7tv.app/*" "*://*.7tv.io/*"];
      platforms = platforms.all;
    };
  };
}
