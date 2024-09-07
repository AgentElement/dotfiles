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
          default = "opnxng.com";
          force = true;
          engines = {
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

      ExtensionSettings = {
        # "*".installation_mode = "blocked";

        # Ublock origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };

        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4246600/bitwarden_password_manager-2024.2.1.xpi";
        };

        # Greasemonkey
        "{e4a8a97b-f2ed-450b-b12d-ee082ba24781}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4208821/greasemonkey-4.12.0.xpi";
        };

        # vimium
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4191523/vimium_ff-2.0.6.xpi";
        };

        # stylus
      };
    };
  };
}
