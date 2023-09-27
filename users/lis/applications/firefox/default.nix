{
  inputs,
  pkgs,
  nixpkgs,
  ...
} @ args: let
in {
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {ExtensionSettings = {};};
    };
    profiles.default = {
      id = 0;
      name = "Default";
      extensions = with (import ./addons.nix args); [
        ublock-origin
        sidebery
        stylus
        languagetool
        enhancer-for-youtube
        augmented-steam
      ];
      settings = {
        # disable about:config warning because we're adults
        "browser.aboutConfig.showWarning" = false;
        # newtab shenanigans
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = false;
        "browser.startup.homepage" = "about:blank";
        # locale shenanigans, other locales are ass
        "intl.accept_languages" = "en-US, en";
        "javascript.use_us_english_locale" = true;
        # disable recommendation pane in about:addons
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        # disable pocket
        "extensions.pocket.enabled" = false;
        # disable telemetry
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
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # disable studies
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        # disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        # enable style customizations (TODO: check if this is needed or setting userChrome enables this anyway)
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # ui looks
        "browser.uiCustomization.state" = ''
          {"placements":{"widget-overflow-fixed-list":["fxa-toolbar-menu-button","sidebar-button"],"unified-extensions-area":["ublock0_raymondhill_net-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","save-to-pocket-button","downloads-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["firefox-view-button","tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["import-button","personal-bookmarks"]},"seen":["developer-button","ublock0_raymondhill_net-browser-action","_3c078156-979c-498b-8990-85f7987dd929_-browser-action","_7a7a4a92-a2a0-41d1-9fd7-1e92480d612d_-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","unified-extensions-area","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list"],"currentVersion":19,"newElementCount":5}
        '';
      };
      userChrome = ''
        /* hide tabs toolbar for sidebery etc. */
        #TabsToolbar {
        display: none;
        }
        #sidebar-header {
        display: none;
        }
      '';
    };
  };
}
