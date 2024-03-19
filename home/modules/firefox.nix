{ lib, pkgs, ... }: {

    home = {
        file.".mozilla/firefox/default/search.json.mozlz4".force = lib.mkForce true;
        packages = with pkgs; [
            nixos-icons
            profile-cleaner
            profile-sync-daemon
        ];
    };

    programs.firefox = {

        enable = true;

        profiles.default = {

            isDefault = true;

            search = {
                default = "DuckDuckGo";
                engines = {
                    "Bing".metaData.hidden = true;
                    "DuckDuckGo".metaData.alias = "@ddg";
                    "Google".metaData.alias = "@g";
                    "Nix Packages" = {
                        icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        metaData.alias = "@nixpkg";
                        urls = [{
                            template = "https://search.nixos.org/packages";
                            params = [
                                { name = "type"; value = "packages"; }
                                { name = "channel"; value = "unstable"; }
                                { name = "query"; value = "{searchTerms}"; }
                            ];
                        }];
                    };
                    "Nix Options" = {
                        icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        metaData.alias = "@nixopt";
                        urls = [{
                            template = "https://search.nixos.org/options";
                            params = [
                                { name = "type"; value = "options"; }
                                { name = "channel"; value = "unstable"; }
                                { name = "query"; value = "{searchTerms}"; }
                            ];
                        }];
                    };
                    "Home Manager Option Search" = {
                        icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                        metaData.alias = "@nixhm";
                        urls = [{
                            template = "https://mipmip.github.io/home-manager-option-search/";
                            params = [
                                { name = "type"; value = "options"; }
                                { name = "query"; value = "{searchTerms}"; }
                            ];
                        }];
                    };
                };
            };

            settings = {

                # Restore Session
                "browser.sessionstore.resume_session_once" = true;

                # Enable custom userChrome
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

                # Disable Pocket with prejudice
                "browser.newtabpage.activity-stream.discoverystream.saveToPocketCard.enabled" = false;
                "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
                "browser.urlbar.suggest.pocket" = false;
                "extensions.pocket.api" = "";
                "extensions.pocket.bffApi" = "";
                "extensions.pocket.enabled" = false;
                "extensions.pocket.oAuthConsumerKey" = "";
                "extensions.pocket.oAuthConsumerKeyBff" = "";
                "extensions.pocket.showHome" = false;
                "extensions.pocket.site" = "";
                "services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket" = false;

                # https mode
                "dom.security.https_only_mode" = true;

                # Disable DRM content
                "media.eme.enabled" = false;

                # Hide the tab bar
                # "browser.tabs.tabmanager.enabled" = false;

                # Remove the full screen warning
                "full-screen-api.warning.timeout" = 0;

                # Security settings from Arch Wiki
                "privacy.firstparty.isolate" = true;
                "general.useragent.override" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.";
                "media.peerconnection.ice.default_address_only" = true;
                "network.captive-portal-service.enabled" = false;
                "toolkit.telemetry.enabled" = false;
                "network.trr.mode" = 5;
                "network.dns.echconfig.enabled" = true;
                "network.dns.http3_echconfig.enabled" = true;
                "browser.safebrowsing.malware.enabled" = false;
                "browser.safebrowsing.phishing.enabled" = false;
                "browser.safebrowsing.downloads.enabled" = false;
                "webgl.disabled" = true;

                # Security settings from librewolf.cfg
                "browser.contentblocking.category" = "strict";

            };

            userChrome = ''
                #TabsToolbar {
                    visibility: collapse;
                }
            '';

        };

    };

    xdg.mimeApps.associations.added = {
        "applications/md" = [ "firefox.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/ftp" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
    };

}
