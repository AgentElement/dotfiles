{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        search = {
          default = "disroot.org";
          force = true;
          engines = {
            "disroot.org" = {
              urls = [
                {
                  template = "https://search.disroot.org";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "safesearch";
                      value = "0";
                    }
                  ];
                }
              ];
            };
            "opnxng.com" = {
              urls = [
                {
                  template = "https://opnxng.com";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "safesearch";
                      value = "0";
                    }
                  ];
                }
              ];
            };
          };
        };

        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          bitwarden
          greasemonkey
          sponsorblock
          vimium
          ublock-origin
          unpaywall
        ];

        settings = {
          "layout.css.devPixelsPerPx" = 1.6;
          "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
          "browser.search.region" = "US";
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.tabs.inTitlebar" = 0;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        };

        containersForce = true;

        containers = {
          banking = {
            id = 1;
            color = "green";
            icon = "dollar";
          };
          asu = {
            id = 2;
            color = "red";
            icon = "fruit";
          };

          music = {
            id = 3;
            color = "purple";
            icon = "chill";
          };
        };
      };
    };

    policies = {
      DontCheckDefaultBrowser = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisplayBookmarksToolbar = "never";
      DisableFirefoxAccounts = false;
      DisableAccounts = false;
      DefaultDownloadDirectory = "/tmp/firefox-downloads/";
    };
  };
}
