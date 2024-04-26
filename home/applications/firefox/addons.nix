{
  pkgs,
  lib,
  ...
}: let
  # stolen from https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/default.nix
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
  "sidebery" = buildFirefoxXpiAddon {
    pname = "sidebery";
    version = "5.2.0";
    addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4246774/sidebery-5.2.0.xpi";
    sha256 = "a5dd94227daafeec200dc2052fae6daa74d1ba261c267b71c03faa4cc4a6fa14";
    meta = with lib; {
      homepage = "https://github.com/mbnuqw/sidebery";
      description = "Vertical tabs tree and bookmarks in sidebar with advanced containers configuration, grouping and many other features.";
      license = licenses.mit;
      mozPermissions = [
        "activeTab"
        "tabs"
        "contextualIdentities"
        "cookies"
        "storage"
        "unlimitedStorage"
        "sessions"
        "menus"
        "menus.overrideContext"
        "search"
        "theme"
      ];
      platforms = platforms.all;
    };
  };

  "ublock-origin" = buildFirefoxXpiAddon {
    pname = "ublock-origin";
    version = "1.57.2";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4261710/ublock_origin-1.57.2.xpi";
    sha256 = "9928e79a52cecf7cfa231fdb0699c7d7a427660d94eb10d711ed5a2f10d2eb89";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      mozPermissions = [
        "alarms"
        "dns"
        "menus"
        "privacy"
        "storage"
        "tabs"
        "unlimitedStorage"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "<all_urls>"
        "http://*/*"
        "https://*/*"
        "file://*/*"
        "https://easylist.to/*"
        "https://*.fanboy.co.nz/*"
        "https://filterlists.com/*"
        "https://forums.lanik.us/*"
        "https://github.com/*"
        "https://*.github.io/*"
        "https://*.letsblock.it/*"
        "https://github.com/uBlockOrigin/*"
        "https://ublockorigin.github.io/*"
        "https://*.reddit.com/r/uBlockOrigin/*"
      ];
      platforms = platforms.all;
    };
  };
  "stylus" = buildFirefoxXpiAddon {
    pname = "stylus";
    version = "1.5.46";
    addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4232144/styl_us-1.5.46.xpi";
    sha256 = "9a75bf1bdde7263a5502d78009b5f19117ea09e6237afc852e7ba4e52b565364";
    meta = with lib; {
      homepage = "https://add0n.com/stylus.html";
      description = "Redesign your favorite websites with Stylus, an actively developed and community driven userstyles manager. Easily install custom themes from popular online repositories, or create, edit, and manage your own personalized CSS stylesheets.";
      license = licenses.gpl3;
      mozPermissions = [
        "tabs"
        "webNavigation"
        "webRequest"
        "webRequestBlocking"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "alarms"
        "<all_urls>"
        "http://userstyles.org/*"
        "https://userstyles.org/*"
      ];
      platforms = platforms.all;
    };
  };
  "languagetool" = buildFirefoxXpiAddon {
    pname = "languagetool";
    version = "8.6.0";
    addonId = "languagetool-webextension@languagetool.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4249956/languagetool-8.6.0.xpi";
    sha256 = "d9db9aac9fdd53eb39179c153161762cd9e9eb1f6d7da8e8b8a32238b4847094";
    meta = with lib; {
      homepage = "https://languagetool.org";
      description = "With this extension you can check text with the free style and grammar checker LanguageTool. It finds many errors that a simple spell checker cannot detect, like mixing up there/their, a/an, or repeating a word.";
      license = {
        shortName = "languagetool";
        fullName = "Custom License for LanguageTool";
        url = "https://languagetool.org/legal/";
        free = false;
      };
      mozPermissions = [
        "activeTab"
        "storage"
        "contextMenus"
        "alarms"
        "http://*/*"
        "https://*/*"
        "file:///*"
        "*://docs.google.com/document/*"
        "*://languagetool.org/*"
      ];
      platforms = platforms.all;
    };
  };
  "enhancer-for-youtube" = buildFirefoxXpiAddon {
    pname = "enhancer-for-youtube";
    version = "2.0.124.2";
    addonId = "enhancerforyoutube@maximerf.addons.mozilla.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4269135/enhancer_for_youtube-2.0.124.2.xpi";
    sha256 = "5e1f6a81207adf2afb8c8860c87f8a7786c384433d128ce3a237b7339b9ee09f";
    meta = with lib; {
      homepage = "https://www.mrfdev.com/enhancer-for-youtube";
      description = "Take control of YouTube and boost your user experience!";
      license = {
        shortName = "enhancer-for-youtube";
        fullName = "Custom License for Enhancer for YouTube™";
        url = "https://addons.mozilla.org/en-US/firefox/addon/enhancer-for-youtube/license/";
        free = false;
      };
      mozPermissions = [
        "cookies"
        "storage"
        "*://www.youtube.com/*"
        "*://www.youtube.com/embed/*"
        "*://www.youtube.com/live_chat*"
        "*://www.youtube.com/pop-up-player/*"
        "*://www.youtube.com/shorts/*"
      ];
      platforms = platforms.all;
    };
  };
  "augmented-steam" = buildFirefoxXpiAddon {
    pname = "augmented-steam";
    version = "3.1.1";
    addonId = "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4264122/augmented_steam-3.1.1.xpi";
    sha256 = "6fab320caaf70a6d4d15f8b266216780beb7da246871b9be1a480e68a0eb9f2f";
    meta = with lib; {
      homepage = "https://augmentedsteam.com/";
      description = "Augments your Steam Experience";
      license = licenses.gpl3;
      mozPermissions = [
        "storage"
        "*://*.steampowered.com/*"
        "*://steamcommunity.com/*"
        "*://*.isthereanydeal.com/"
        "webRequest"
        "webRequestBlocking"
        "contextMenus"
        "*://steamcommunity.com/app/*"
        "*://steamcommunity.com/sharedfiles/editguide/?*"
        "*://steamcommunity.com/sharedfiles/editguide?*"
        "*://steamcommunity.com/workshop/editguide/?*"
        "*://steamcommunity.com/workshop/editguide?*"
        "*://steamcommunity.com/id/*/badges"
        "*://steamcommunity.com/id/*/badges/"
        "*://steamcommunity.com/id/*/badges/?*"
        "*://steamcommunity.com/id/*/badges?*"
        "*://steamcommunity.com/profiles/*/badges"
        "*://steamcommunity.com/profiles/*/badges/"
        "*://steamcommunity.com/profiles/*/badges/?*"
        "*://steamcommunity.com/profiles/*/badges?*"
        "*://steamcommunity.com/tradingcards/boostercreator"
        "*://steamcommunity.com/tradingcards/boostercreator/"
        "*://steamcommunity.com/tradingcards/boostercreator/?*"
        "*://steamcommunity.com/tradingcards/boostercreator?*"
        "*://steamcommunity.com/stats/*/achievements"
        "*://steamcommunity.com/stats/*/achievements/"
        "*://steamcommunity.com/stats/*/achievements/?*"
        "*://steamcommunity.com/stats/*/achievements?*"
        "*://steamcommunity.com/id/*/friendsthatplay/*"
        "*://steamcommunity.com/profiles/*/friendsthatplay/*"
        "*://steamcommunity.com/id/*/gamecards/*"
        "*://steamcommunity.com/profiles/*/gamecards/*"
        "*://steamcommunity.com/id/*/friends"
        "*://steamcommunity.com/id/*/friends/*"
        "*://steamcommunity.com/id/*/friends?*"
        "*://steamcommunity.com/profiles/*/friends"
        "*://steamcommunity.com/profiles/*/friends/*"
        "*://steamcommunity.com/profiles/*/friends?*"
        "*://steamcommunity.com/id/*/groups"
        "*://steamcommunity.com/id/*/groups/*"
        "*://steamcommunity.com/id/*/groups?*"
        "*://steamcommunity.com/profiles/*/groups"
        "*://steamcommunity.com/profiles/*/groups/*"
        "*://steamcommunity.com/profiles/*/groups?*"
        "*://steamcommunity.com/id/*/following"
        "*://steamcommunity.com/id/*/following/*"
        "*://steamcommunity.com/id/*/following?*"
        "*://steamcommunity.com/profiles/*/following"
        "*://steamcommunity.com/profiles/*/following/*"
        "*://steamcommunity.com/profiles/*/following?*"
        "*://steamcommunity.com/id/*/games"
        "*://steamcommunity.com/id/*/games/"
        "*://steamcommunity.com/id/*/games/?*"
        "*://steamcommunity.com/id/*/games?*"
        "*://steamcommunity.com/profiles/*/games"
        "*://steamcommunity.com/profiles/*/games/"
        "*://steamcommunity.com/profiles/*/games/?*"
        "*://steamcommunity.com/profiles/*/games?*"
        "*://steamcommunity.com/id/*/followedgames"
        "*://steamcommunity.com/id/*/followedgames/"
        "*://steamcommunity.com/id/*/followedgames/?*"
        "*://steamcommunity.com/id/*/followedgames?*"
        "*://steamcommunity.com/profiles/*/followedgames"
        "*://steamcommunity.com/profiles/*/followedgames/"
        "*://steamcommunity.com/profiles/*/followedgames/?*"
        "*://steamcommunity.com/profiles/*/followedgames?*"
        "*://steamcommunity.com/groups/*"
        "*://steamcommunity.com/app/*/guides"
        "*://steamcommunity.com/app/*/guides/"
        "*://steamcommunity.com/app/*/guides/?*"
        "*://steamcommunity.com/app/*/guides?*"
        "*://steamcommunity.com/market"
        "*://steamcommunity.com/market/"
        "*://steamcommunity.com/market/?*"
        "*://steamcommunity.com/market?*"
        "*://steamcommunity.com/id/*/inventory"
        "*://steamcommunity.com/id/*/inventory/"
        "*://steamcommunity.com/id/*/inventory/?*"
        "*://steamcommunity.com/id/*/inventory?*"
        "*://steamcommunity.com/profiles/*/inventory"
        "*://steamcommunity.com/profiles/*/inventory/"
        "*://steamcommunity.com/profiles/*/inventory/?*"
        "*://steamcommunity.com/profiles/*/inventory?*"
        "*://steamcommunity.com/id/*/home"
        "*://steamcommunity.com/id/*/home/"
        "*://steamcommunity.com/id/*/home/?*"
        "*://steamcommunity.com/id/*/home?*"
        "*://steamcommunity.com/profiles/*/home"
        "*://steamcommunity.com/profiles/*/home/"
        "*://steamcommunity.com/profiles/*/home/?*"
        "*://steamcommunity.com/profiles/*/home?*"
        "*://steamcommunity.com/id/*/myactivity"
        "*://steamcommunity.com/id/*/myactivity/"
        "*://steamcommunity.com/id/*/myactivity/?*"
        "*://steamcommunity.com/id/*/myactivity?*"
        "*://steamcommunity.com/profiles/*/myactivity"
        "*://steamcommunity.com/profiles/*/myactivity/"
        "*://steamcommunity.com/profiles/*/myactivity/?*"
        "*://steamcommunity.com/profiles/*/myactivity?*"
        "*://steamcommunity.com/id/*/friendactivitydetail/*"
        "*://steamcommunity.com/profiles/*/friendactivitydetail/*"
        "*://steamcommunity.com/id/*/status/*"
        "*://steamcommunity.com/profiles/*/status/*"
        "*://steamcommunity.com/id/*/edit/*"
        "*://steamcommunity.com/profiles/*/edit/*"
        "*://steamcommunity.com/id/*"
        "*://steamcommunity.com/profiles/*"
        "*://steamcommunity.com/market/listings/*"
        "*://steamcommunity.com/market/search"
        "*://steamcommunity.com/market/search/*"
        "*://steamcommunity.com/market/search?*"
        "*://steamcommunity.com/id/*/stats/*"
        "*://steamcommunity.com/profiles/*/stats/*"
        "*://steamcommunity.com/id/*/recommended"
        "*://steamcommunity.com/id/*/recommended/"
        "*://steamcommunity.com/id/*/recommended/?*"
        "*://steamcommunity.com/id/*/recommended?*"
        "*://steamcommunity.com/profiles/*/recommended"
        "*://steamcommunity.com/profiles/*/recommended/"
        "*://steamcommunity.com/profiles/*/recommended/?*"
        "*://steamcommunity.com/profiles/*/recommended?*"
        "*://steamcommunity.com/id/*/reviews"
        "*://steamcommunity.com/id/*/reviews/"
        "*://steamcommunity.com/id/*/reviews/?*"
        "*://steamcommunity.com/id/*/reviews?*"
        "*://steamcommunity.com/profiles/*/reviews"
        "*://steamcommunity.com/profiles/*/reviews/"
        "*://steamcommunity.com/profiles/*/reviews/?*"
        "*://steamcommunity.com/profiles/*/reviews?*"
        "*://*.steampowered.com/points"
        "*://*.steampowered.com/points/*"
        "*://*.steampowered.com/points?*"
        "*://steamcommunity.com/id/*/myworkshopfiles/?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/id/*/myworkshopfiles?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/profiles/*/myworkshopfiles/?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/profiles/*/myworkshopfiles?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/sharedfiles/filedetails"
        "*://steamcommunity.com/sharedfiles/filedetails/*"
        "*://steamcommunity.com/sharedfiles/filedetails?*"
        "*://steamcommunity.com/workshop/filedetails"
        "*://steamcommunity.com/workshop/filedetails/*"
        "*://steamcommunity.com/workshop/filedetails?*"
        "*://*.steampowered.com/charts"
        "*://*.steampowered.com/charts/*"
        "*://*.steampowered.com/charts?*"
        "*://*.steampowered.com/account"
        "*://*.steampowered.com/account/"
        "*://*.steampowered.com/account/?*"
        "*://*.steampowered.com/account?*"
        "*://*.steampowered.com/agecheck/*"
        "*://store.steampowered.com/"
        "*://store.steampowered.com/?*"
        "*://*.steampowered.com/app/*"
        "*://steamcommunity.com/tradeoffer/*"
        "*://*.steampowered.com/steamaccount/addfunds"
        "*://*.steampowered.com/steamaccount/addfunds/"
        "*://*.steampowered.com/steamaccount/addfunds/?*"
        "*://*.steampowered.com/steamaccount/addfunds?*"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard/"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard/?*"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard?*"
        "*://steamcommunity.com/sharedfiles"
        "*://steamcommunity.com/sharedfiles/"
        "*://steamcommunity.com/sharedfiles/?*"
        "*://steamcommunity.com/sharedfiles?*"
        "*://steamcommunity.com/workshop"
        "*://steamcommunity.com/workshop/"
        "*://steamcommunity.com/workshop/?*"
        "*://steamcommunity.com/workshop?*"
        "*://*.steampowered.com/bundle/*"
        "*://store.steampowered.com/account/licenses"
        "*://store.steampowered.com/account/licenses/"
        "*://store.steampowered.com/account/licenses/?*"
        "*://store.steampowered.com/account/licenses?*"
        "*://*.steampowered.com/cart"
        "*://*.steampowered.com/cart/*"
        "*://*.steampowered.com/cart?*"
        "*://*.steampowered.com/account/registerkey"
        "*://*.steampowered.com/account/registerkey/"
        "*://*.steampowered.com/account/registerkey/?*"
        "*://*.steampowered.com/account/registerkey?*"
        "*://*.steampowered.com/search"
        "*://*.steampowered.com/search/*"
        "*://*.steampowered.com/search?*"
        "*://*.steampowered.com/wishlist/id/*"
        "*://*.steampowered.com/wishlist/profiles/*"
        "*://*.steampowered.com/sub/*"
        "*://steamcommunity.com/sharedfiles/browse"
        "*://steamcommunity.com/sharedfiles/browse/"
        "*://steamcommunity.com/sharedfiles/browse/?*"
        "*://steamcommunity.com/sharedfiles/browse?*"
        "*://steamcommunity.com/workshop/browse"
        "*://steamcommunity.com/workshop/browse/"
        "*://steamcommunity.com/workshop/browse/?*"
        "*://steamcommunity.com/workshop/browse?*"
      ];
      platforms = platforms.all;
    };
  };
  "sponsorblock" = buildFirefoxXpiAddon {
    pname = "sponsorblock";
    version = "5.5.9";
    addonId = "sponsorBlocker@ajay.app";
    url = "https://addons.mozilla.org/firefox/downloads/file/4251917/sponsorblock-5.5.9.xpi";
    sha256 = "a4ea4938ca5375c3de6966caec5cd63ae458788830abdab49a700fdc39d80f58";
    meta = with lib; {
      homepage = "https://sponsor.ajay.app";
      description = "Easily skip YouTube video sponsors. When you visit a YouTube video, the extension will check the database for reported sponsors and automatically skip known sponsors. You can also report sponsors in videos. Other browsers: https://sponsor.ajay.app";
      license = licenses.lgpl3;
      mozPermissions = [
        "storage"
        "https://sponsor.ajay.app/*"
        "scripting"
        "https://*.youtube.com/*"
        "https://www.youtube-nocookie.com/embed/*"
      ];
      platforms = platforms.all;
    };
  };
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
  "bitwarden" = buildFirefoxXpiAddon {
    pname = "bitwarden";
    version = "2024.4.1";
    addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4263752/bitwarden_password_manager-2024.4.1.xpi";
    sha256 = "1ba1e66cb9a4ee3bf80a81fc31348b04162385455d2b02f9902473e3931d9693";
    meta = with lib; {
      homepage = "https://bitwarden.com";
      description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
      license = licenses.gpl3;
      mozPermissions = [
        "<all_urls>"
        "*://*/*"
        "tabs"
        "contextMenus"
        "storage"
        "unlimitedStorage"
        "clipboardRead"
        "clipboardWrite"
        "idle"
        "webRequest"
        "webRequestBlocking"
        "file:///*"
        "https://*/*"
        "https://lastpass.com/export.php"
      ];
      platforms = platforms.all;
    };
  };
}
