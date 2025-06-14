{
  inputs,
  pkgs,
  lib,
  options,
  ...
}: let
  custom = import ./addons.nix {inherit pkgs lib;};
  firefoxAddons = pkgs.callPackage inputs.firefox-addons {};
in
  lib.mkMerge [
    {
      home.sessionVariables = {
        BROWSER = "firefox";
        MOZ_USE_XINPUT2 = "1";
      };
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-bin;
        profiles.default = {
          id = 0;
          name = "default";
          extensions.packages = with firefoxAddons;
            [
              augmented-steam
              clearurls
              decentraleyes
              enhancer-for-youtube
              languagetool
              onepassword-password-manager
              privacy-badger
              refined-github
              sponsorblock
              stylus
              ublock-origin
            ]
            ++ [
              custom.seventv-nightly
            ];
          settings = {
            "browser.aboutConfig.showWarning" = false;
            "browser.startup.homepage" = "about:blank";
            "browser.toolbars.bookmarks.visibility" = "never";
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
            "extensions.autoDisableScopes" = 0;

            # privacy & telemetry ahoy
            "privacy.trackingprotection.enabled" = true;
            "privacy.trackingprotection.socialtracking.enabled" = true;
            "privacy.partition.serviceWorkers" = true;
            "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
            "privacy.firstparty.isolate" = false;
            "network.cookie.cookieBehavior" = 5;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "toolkit.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";
            "browser.ping-centre.telemetry" = false;
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;

            # sponsored content yuck!
            "browser.newtabpage.enabled" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.default.sites" = "";
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;
            "extensions.pocket.enabled" = false;

            # i'm not much for studying
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";

            # performance
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "widget.dmabuf.force-enabled" = true;
            "media.av1.enabled" = true;
            "image.avif.enabled" = true;

            # developer
            "devtools.chrome.enabled" = true;
            "devtools.debugger.remote-enabled" = true;

            # locale
            "intl.accept_languages" = "en-US, en";
            "javascript.use_us_english_locale" = true;

            # ui
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.theme.dark-private-windows" = false;
            "extensions.activeThemeID" = "default-theme@mozilla.org";
            "browser.uiCustomization.state" = ''
              {"placements":{"widget-overflow-fixed-list":["fxa-toolbar-menu-button"],"unified-extensions-area":["jid1-mnnxcxisbpnsxq_jetpack-browser-action","sponsorblocker_ajay_app-browser-action","moz-addon_7tv_app-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","languagetool-webextension_languagetool_org-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","jid1-om7ejgwa1u8akg_jetpack-browser-action","_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","vertical-spacer","stop-reload-button","urlbar-container","save-to-pocket-button","reset-pbm-toolbar-button","ublock0_raymondhill_net-browser-action","downloads-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action","profiler-button","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","languagetool-webextension_languagetool_org-browser-action","moz-addon_7tv_app-browser-action","sponsorblocker_ajay_app-browser-action","_74145f27-f039-47ce-a470-a662b129930a_-browser-action","jid1-bofifl9vbdl2zq_jetpack-browser-action","jid1-om7ejgwa1u8akg_jetpack-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","_a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list","vertical-tabs"],"currentVersion":22,"newElementCount":7}
            '';
          };
        };
      };
    }
    (lib.optionalAttrs (options ? home.persistence) {
      # persistence for firefox (TODO: fix hardcoded username)
      home.persistence."/persist/home/lis" = {
        directories = [
          ".mozilla"
          ".cache/mozilla"
        ];
      };
    })
  ]
