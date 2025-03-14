{ lib, pkgs, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.homeImpermanence {
        "/nix".users.${sysConfig.user}.directories = [
            { directory = ".librewolf"; mode = "0700"; }
        ];
    };

    home-manager.users.${sysConfig.user} = {

        # home.file.".librewolf/default/search.json.mozlz4".force = lib.mkForce true;

        home.packages = with pkgs; [
            nixos-icons
            profile-cleaner
            profile-sync-daemon
        ];

        programs.librewolf = {

            enable = true;

            # profiles.default = {
            #
            #     isDefault = true;
            #
            #     search = {
            #         default = "DuckDuckGo";
            #         engines = {
            #             "Bing".metaData.hidden = true;
            #             "DuckDuckGo".metaData.alias = "@ddg";
            #             "Google".metaData.alias = "@g";
            #             "Nix Packages" = {
            #                 icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            #                 metaData.alias = "@nixpkg";
            #                 urls = [{
            #                     template = "https://search.nixos.org/packages";
            #                     params = [
            #                         { name = "type"; value = "packages"; }
            #                         { name = "channel"; value = "unstable"; }
            #                         { name = "query"; value = "{searchTerms}"; }
            #                     ];
            #                 }];
            #             };
            #             "Nix Options" = {
            #                 icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            #                 metaData.alias = "@nixopt";
            #                 urls = [{
            #                     template = "https://search.nixos.org/options";
            #                     params = [
            #                         { name = "type"; value = "options"; }
            #                         { name = "channel"; value = "unstable"; }
            #                         { name = "query"; value = "{searchTerms}"; }
            #                     ];
            #                 }];
            #             };
            #             "Home Manager Option Search" = {
            #                 icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            #                 metaData.alias = "@nixhm";
            #                 urls = [{
            #                     template = "https://mipmip.github.io/home-manager-option-search/";
            #                     params = [
            #                         { name = "type"; value = "options"; }
            #                         { name = "query"; value = "{searchTerms}"; }
            #                     ];
            #                 }];
            #             };
            #         };
            #     };

            settings = let

                ffVersion = builtins.substring 0 5 pkgs.librewolf.version;

            in {
                "browser.compactmode.show" = true;
                "browser.startup.page" = 3;
                "extensions.unifiedExtensions.enabled" = false;
                "general.useragent.override" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:${ffVersion}) Gecko/20100101 Firefox/${ffVersion}";
                "general.platform.override" = "Win32";
                "identity.fxaccounts.enabled" = true;
                "media.ffmpeg.vaapi.enabled" = true;
                "network.cookie.lifetimePolicy" = 0;
                "privacy.clearOnShutdown.cookies" = false;
                "privacy.clearOnShutdown.history" = false;
                "privacy.firstparty.isolate" = true;
                "privacy.resistFingerprinting" = false;
                "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                "webgl.disabled" = false;
            };

            # };

        };

        xdg.mimeApps.associations.added = {
            "applications/md" = [ "librewolf.desktop" ];
            "text/html" = [ "librewolf.desktop" ];
            "x-scheme-handler/ftp" = [ "librewolf.desktop" ];
            "x-scheme-handler/http" = [ "librewolf.desktop" ];
            "x-scheme-handler/https" = [ "librewolf.desktop" ];
        };

    };

}
