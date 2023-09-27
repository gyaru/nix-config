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
    version = "5.0.0";
    addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4170134/sidebery-5.0.0.xpi";
    sha256 = "f592427a1c68d3e51aee208d05588f39702496957771fd84b76a93e364138bf5";
    meta = with lib; {
      homepage = "https://github.com/mbnuqw/sidebery";
      description = "Tabs tree and bookmarks in sidebar with advanced containers configuration.";
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
    version = "1.52.2";
    addonId = "uBlock0@raymondhill.net";
    url = "https://addons.mozilla.org/firefox/downloads/file/4171020/ublock_origin-1.52.2.xpi";
    sha256 = "e8ee3f9d597a6d42db9d73fe87c1d521de340755fd8bfdd69e41623edfe096d6";
    meta = with lib; {
      homepage = "https://github.com/gorhill/uBlock#ublock-origin";
      description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
      license = licenses.gpl3;
      mozPermissions = [
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
      ];
      platforms = platforms.all;
    };
  };
  "stylus" = buildFirefoxXpiAddon {
    pname = "stylus";
    version = "1.5.35";
    addonId = "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4160414/styl_us-1.5.35.xpi";
    sha256 = "d415ee11fa4a4313096a268e54fd80fa93143345be16f417eb1300a6ebe26ba1";
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
    version = "7.1.13";
    addonId = "languagetool-webextension@languagetool.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4128570/languagetool-7.1.13.xpi";
    sha256 = "e9002ae915c74ff2fe2f986e86a50b0b1617bcd852443e3d5b8e733e476c5808";
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
    version = "2.0.121";
    addonId = "enhancerforyoutube@maximerf.addons.mozilla.org";
    url = "https://addons.mozilla.org/firefox/downloads/file/4157491/enhancer_for_youtube-2.0.121.xpi";
    sha256 = "baaba2f8eef7166c1bee8975be63fc2c28d65f0ee48c8a0d1c1744b66db8a2ad";
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
    version = "2.6.0";
    addonId = "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}";
    url = "https://addons.mozilla.org/firefox/downloads/file/4167723/augmented_steam-2.6.0.xpi";
    sha256 = "949f9f8c8a932cbaee3fea6ccbb25a34fa1d260c61df78e5c384bdf7d4118c59";
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
        "*://store.steampowered.com/?*"
        "*://store.steampowered.com/"
        "*://*.steampowered.com/wishlist/id/*"
        "*://*.steampowered.com/wishlist/profiles/*"
        "*://*.steampowered.com/charts/*"
        "*://*.steampowered.com/charts"
        "*://*.steampowered.com/charts?*"
        "*://*.steampowered.com/search/*"
        "*://*.steampowered.com/search"
        "*://*.steampowered.com/search?*"
        "*://*.steampowered.com/steamaccount/addfunds"
        "*://*.steampowered.com/steamaccount/addfunds?*"
        "*://*.steampowered.com/steamaccount/addfunds/"
        "*://*.steampowered.com/steamaccount/addfunds/?*"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard?*"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard/"
        "*://*.steampowered.com/digitalgiftcards/selectgiftcard/?*"
        "*://*.steampowered.com/account"
        "*://*.steampowered.com/account?*"
        "*://*.steampowered.com/account/"
        "*://*.steampowered.com/account/?*"
        "*://store.steampowered.com/account/licenses"
        "*://store.steampowered.com/account/licenses?*"
        "*://store.steampowered.com/account/licenses/"
        "*://store.steampowered.com/account/licenses/?*"
        "*://*.steampowered.com/account/registerkey"
        "*://*.steampowered.com/account/registerkey?*"
        "*://*.steampowered.com/account/registerkey/"
        "*://*.steampowered.com/account/registerkey/?*"
        "*://*.steampowered.com/bundle/*"
        "*://*.steampowered.com/sub/*"
        "*://*.steampowered.com/app/*"
        "*://*.steampowered.com/agecheck/*"
        "*://*.steampowered.com/points/*"
        "*://*.steampowered.com/points"
        "*://*.steampowered.com/points?*"
        "*://*.steampowered.com/cart/*"
        "*://*.steampowered.com/cart"
        "*://*.steampowered.com/cart?*"
        "*://steamcommunity.com/sharedfiles"
        "*://steamcommunity.com/sharedfiles?*"
        "*://steamcommunity.com/sharedfiles/"
        "*://steamcommunity.com/sharedfiles/?*"
        "*://steamcommunity.com/workshop"
        "*://steamcommunity.com/workshop?*"
        "*://steamcommunity.com/workshop/"
        "*://steamcommunity.com/workshop/?*"
        "*://steamcommunity.com/sharedfiles/browse"
        "*://steamcommunity.com/sharedfiles/browse?*"
        "*://steamcommunity.com/sharedfiles/browse/"
        "*://steamcommunity.com/sharedfiles/browse/?*"
        "*://steamcommunity.com/workshop/browse"
        "*://steamcommunity.com/workshop/browse?*"
        "*://steamcommunity.com/workshop/browse/"
        "*://steamcommunity.com/workshop/browse/?*"
        "*://steamcommunity.com/id/*/home"
        "*://steamcommunity.com/id/*/home?*"
        "*://steamcommunity.com/id/*/home/"
        "*://steamcommunity.com/id/*/home/?*"
        "*://steamcommunity.com/profiles/*/home"
        "*://steamcommunity.com/profiles/*/home?*"
        "*://steamcommunity.com/profiles/*/home/"
        "*://steamcommunity.com/profiles/*/home/?*"
        "*://steamcommunity.com/id/*/myactivity"
        "*://steamcommunity.com/id/*/myactivity?*"
        "*://steamcommunity.com/id/*/myactivity/"
        "*://steamcommunity.com/id/*/myactivity/?*"
        "*://steamcommunity.com/profiles/*/myactivity"
        "*://steamcommunity.com/profiles/*/myactivity?*"
        "*://steamcommunity.com/profiles/*/myactivity/"
        "*://steamcommunity.com/profiles/*/myactivity/?*"
        "*://steamcommunity.com/id/*/friendactivitydetail/*"
        "*://steamcommunity.com/profiles/*/friendactivitydetail/*"
        "*://steamcommunity.com/id/*/status/*"
        "*://steamcommunity.com/profiles/*/status/*"
        "*://steamcommunity.com/id/*/games"
        "*://steamcommunity.com/id/*/games?*"
        "*://steamcommunity.com/id/*/games/"
        "*://steamcommunity.com/id/*/games/?*"
        "*://steamcommunity.com/profiles/*/games"
        "*://steamcommunity.com/profiles/*/games?*"
        "*://steamcommunity.com/profiles/*/games/"
        "*://steamcommunity.com/profiles/*/games/?*"
        "*://steamcommunity.com/id/*/followedgames"
        "*://steamcommunity.com/id/*/followedgames?*"
        "*://steamcommunity.com/id/*/followedgames/"
        "*://steamcommunity.com/id/*/followedgames/?*"
        "*://steamcommunity.com/profiles/*/followedgames"
        "*://steamcommunity.com/profiles/*/followedgames?*"
        "*://steamcommunity.com/profiles/*/followedgames/"
        "*://steamcommunity.com/profiles/*/followedgames/?*"
        "*://steamcommunity.com/id/*/edit/*"
        "*://steamcommunity.com/profiles/*/edit/*"
        "*://steamcommunity.com/id/*/badges"
        "*://steamcommunity.com/id/*/badges?*"
        "*://steamcommunity.com/id/*/badges/"
        "*://steamcommunity.com/id/*/badges/?*"
        "*://steamcommunity.com/profiles/*/badges"
        "*://steamcommunity.com/profiles/*/badges?*"
        "*://steamcommunity.com/profiles/*/badges/"
        "*://steamcommunity.com/profiles/*/badges/?*"
        "*://steamcommunity.com/id/*/gamecards/*"
        "*://steamcommunity.com/profiles/*/gamecards/*"
        "*://steamcommunity.com/id/*/friendsthatplay/*"
        "*://steamcommunity.com/profiles/*/friendsthatplay/*"
        "*://steamcommunity.com/id/*/friends/*"
        "*://steamcommunity.com/id/*/friends"
        "*://steamcommunity.com/id/*/friends?*"
        "*://steamcommunity.com/profiles/*/friends/*"
        "*://steamcommunity.com/profiles/*/friends"
        "*://steamcommunity.com/profiles/*/friends?*"
        "*://steamcommunity.com/id/*/groups/*"
        "*://steamcommunity.com/id/*/groups"
        "*://steamcommunity.com/id/*/groups?*"
        "*://steamcommunity.com/profiles/*/groups/*"
        "*://steamcommunity.com/profiles/*/groups"
        "*://steamcommunity.com/profiles/*/groups?*"
        "*://steamcommunity.com/id/*/following/*"
        "*://steamcommunity.com/id/*/following"
        "*://steamcommunity.com/id/*/following?*"
        "*://steamcommunity.com/profiles/*/following/*"
        "*://steamcommunity.com/profiles/*/following"
        "*://steamcommunity.com/profiles/*/following?*"
        "*://steamcommunity.com/id/*/inventory"
        "*://steamcommunity.com/id/*/inventory?*"
        "*://steamcommunity.com/id/*/inventory/"
        "*://steamcommunity.com/id/*/inventory/?*"
        "*://steamcommunity.com/profiles/*/inventory"
        "*://steamcommunity.com/profiles/*/inventory?*"
        "*://steamcommunity.com/profiles/*/inventory/"
        "*://steamcommunity.com/profiles/*/inventory/?*"
        "*://steamcommunity.com/market/listings/*"
        "*://steamcommunity.com/market/search/*"
        "*://steamcommunity.com/market/search"
        "*://steamcommunity.com/market/search?*"
        "*://steamcommunity.com/market"
        "*://steamcommunity.com/market?*"
        "*://steamcommunity.com/market/"
        "*://steamcommunity.com/market/?*"
        "*://steamcommunity.com/id/*/stats/*"
        "*://steamcommunity.com/profiles/*/stats/*"
        "*://steamcommunity.com/id/*/myworkshopfiles/?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/id/*/myworkshopfiles?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/profiles/*/myworkshopfiles/?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/profiles/*/myworkshopfiles?*browsefilter=mysubscriptions*"
        "*://steamcommunity.com/id/*/recommended"
        "*://steamcommunity.com/id/*/recommended?*"
        "*://steamcommunity.com/id/*/recommended/"
        "*://steamcommunity.com/id/*/recommended/?*"
        "*://steamcommunity.com/profiles/*/recommended"
        "*://steamcommunity.com/profiles/*/recommended?*"
        "*://steamcommunity.com/profiles/*/recommended/"
        "*://steamcommunity.com/profiles/*/recommended/?*"
        "*://steamcommunity.com/id/*/reviews"
        "*://steamcommunity.com/id/*/reviews?*"
        "*://steamcommunity.com/id/*/reviews/"
        "*://steamcommunity.com/id/*/reviews/?*"
        "*://steamcommunity.com/profiles/*/reviews"
        "*://steamcommunity.com/profiles/*/reviews?*"
        "*://steamcommunity.com/profiles/*/reviews/"
        "*://steamcommunity.com/profiles/*/reviews/?*"
        "*://steamcommunity.com/id/*"
        "*://steamcommunity.com/profiles/*"
        "*://steamcommunity.com/groups/*"
        "*://steamcommunity.com/app/*/guides"
        "*://steamcommunity.com/app/*/guides?*"
        "*://steamcommunity.com/app/*/guides/"
        "*://steamcommunity.com/app/*/guides/?*"
        "*://steamcommunity.com/app/*"
        "*://steamcommunity.com/sharedfiles/filedetails/*"
        "*://steamcommunity.com/sharedfiles/filedetails"
        "*://steamcommunity.com/sharedfiles/filedetails?*"
        "*://steamcommunity.com/workshop/filedetails/*"
        "*://steamcommunity.com/workshop/filedetails"
        "*://steamcommunity.com/workshop/filedetails?*"
        "*://steamcommunity.com/sharedfiles/editguide/?*"
        "*://steamcommunity.com/sharedfiles/editguide?*"
        "*://steamcommunity.com/workshop/editguide/?*"
        "*://steamcommunity.com/workshop/editguide?*"
        "*://steamcommunity.com/tradingcards/boostercreator"
        "*://steamcommunity.com/tradingcards/boostercreator?*"
        "*://steamcommunity.com/tradingcards/boostercreator/"
        "*://steamcommunity.com/tradingcards/boostercreator/?*"
        "*://steamcommunity.com/stats/*/achievements"
        "*://steamcommunity.com/stats/*/achievements?*"
        "*://steamcommunity.com/stats/*/achievements/"
        "*://steamcommunity.com/stats/*/achievements/?*"
        "*://steamcommunity.com/tradeoffer/*"
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
}
