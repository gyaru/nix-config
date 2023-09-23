{
  inputs,
  pkgs,
  nixpkgs,
  ...
}: let
  addons = inputs.firefox-addons.packages.${pkgs.system};
in {
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {ExtensionSettings = {};};
    };
    profiles.default = {
      id = 0;
      name = "Default";
      extensions = with addons; [
        ublock-origin
        sidebery
        stylus
        # languagetool # allowUnfree = true; somehow still not applied here, wat.
        # enhancer-for-youtube
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
