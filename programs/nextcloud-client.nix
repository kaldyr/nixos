{ lib, pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [ ".config/Nextcloud" ];

    home-manager.users.${sysConfig.user} = let
    
        ncInitialConfig = pkgs.writeText "ncInitialConfig" /* ini */ ''
            [General]
            launchOnSystemStartup=true

            [Accounts]
            0\Folders\1\ignoreHiddenFiles=false
            0\Folders\1\localPath=/home/${sysConfig.user}/Notes/
            0\Folders\1\paused=false
            0\Folders\1\targetPath=/Notes
            0\Folders\1\version=2
            0\Folders\1\virtualFilesMode=off
            0\Folders\10\ignoreHiddenFiles=false
            0\Folders\10\localPath=/home/${sysConfig.user}/Videos/Brightwheel/
            0\Folders\10\paused=false
            0\Folders\10\targetPath=/Videos/Brightwheel
            0\Folders\10\version=2
            0\Folders\10\virtualFilesMode=off
            0\Folders\11\ignoreHiddenFiles=false
            0\Folders\11\localPath=/home/${sysConfig.user}/Videos/Canon/
            0\Folders\11\paused=false
            0\Folders\11\targetPath=/Videos/Canon
            0\Folders\11\version=2
            0\Folders\11\virtualFilesMode=off
            0\Folders\12\ignoreHiddenFiles=false
            0\Folders\12\localPath=/home/${sysConfig.user}/Videos/Phone/
            0\Folders\12\paused=false
            0\Folders\12\targetPath=/Videos/Phone
            0\Folders\12\version=2
            0\Folders\12\virtualFilesMode=off
            0\Folders\13\ignoreHiddenFiles=false
            0\Folders\13\localPath=/home/${sysConfig.user}/Videos/Saved/
            0\Folders\13\paused=false
            0\Folders\13\targetPath=/Videos/Saved
            0\Folders\13\version=2
            0\Folders\13\virtualFilesMode=off
            0\Folders\14\ignoreHiddenFiles=false
            0\Folders\14\localPath=/home/${sysConfig.user}/Videos/Screenrec/
            0\Folders\14\paused=false
            0\Folders\14\targetPath=/Videos/Screenrec
            0\Folders\14\version=2
            0\Folders\14\virtualFilesMode=off
            0\Folders\15\ignoreHiddenFiles=false
            0\Folders\15\localPath=/home/${sysConfig.user}/Music/
            0\Folders\15\paused=false
            0\Folders\15\targetPath=/Music
            0\Folders\15\version=2
            0\Folders\15\virtualFilesMode=off
            0\Folders\2\ignoreHiddenFiles=false
            0\Folders\2\localPath=/home/${sysConfig.user}/Pictures/Brightwheel/
            0\Folders\2\paused=false
            0\Folders\2\targetPath=/Pictures/Brightwheel
            0\Folders\2\version=2
            0\Folders\2\virtualFilesMode=off
            0\Folders\3\ignoreHiddenFiles=false
            0\Folders\3\localPath=/home/${sysConfig.user}/Pictures/Canon/
            0\Folders\3\paused=false
            0\Folders\3\targetPath=/Pictures/Canon
            0\Folders\3\version=2
            0\Folders\3\virtualFilesMode=off
            0\Folders\4\ignoreHiddenFiles=false
            0\Folders\4\localPath=/home/${sysConfig.user}/Documents/
            0\Folders\4\paused=false
            0\Folders\4\targetPath=/Documents
            0\Folders\4\version=2
            0\Folders\4\virtualFilesMode=off
            0\Folders\5\ignoreHiddenFiles=false
            0\Folders\5\localPath=/home/${sysConfig.user}/Pictures/Messaging/
            0\Folders\5\paused=false
            0\Folders\5\targetPath=/Pictures/Messaging
            0\Folders\5\version=2
            0\Folders\5\virtualFilesMode=off
            0\Folders\6\ignoreHiddenFiles=false
            0\Folders\6\localPath=/home/${sysConfig.user}/Pictures/Phone/
            0\Folders\6\paused=false
            0\Folders\6\targetPath=/Pictures/Phone
            0\Folders\6\version=2
            0\Folders\6\virtualFilesMode=off
            0\Folders\7\ignoreHiddenFiles=false
            0\Folders\7\localPath=/home/${sysConfig.user}/Pictures/Saved/
            0\Folders\7\paused=false
            0\Folders\7\targetPath=/Pictures/Saved
            0\Folders\7\version=2
            0\Folders\7\virtualFilesMode=off
            0\Folders\8\ignoreHiddenFiles=false
            0\Folders\8\localPath=/home/${sysConfig.user}/Pictures/Screenshots/
            0\Folders\8\paused=false
            0\Folders\8\targetPath=/Pictures/Screenshots
            0\Folders\8\version=2
            0\Folders\8\virtualFilesMode=off
            0\Folders\9\ignoreHiddenFiles=false
            0\Folders\9\localPath=/home/${sysConfig.user}/Pictures/Wallpapers/
            0\Folders\9\paused=false
            0\Folders\9\targetPath=/Pictures/Wallpapers
            0\Folders\9\version=2
            0\Folders\9\virtualFilesMode=off
            0\authType=webflow
            0\dav_user=${sysConfig.user}
            0\url=https://magrathea.brill-godzilla.ts.net
            0\version=1
            0\webflow_user=${sysConfig.user}
        '';

    in  {

        home.activation.initConfig = lib.mkAfter /* bash */ ''
            if [ ! -d "/home/${sysConfig.user}/.config/Nextcloud" ]; then
                mkdir -p "/home/${sysConfig.user}/.config/Nextcloud"
            fi

            cd "/home/${sysConfig.user}/.config/Nextcloud"

            if [ ! -f "nextcloud.cfg" ]; then
                cat ${ncInitialConfig} > nextcloud.cfg
            fi
        '';

        home.packages = with pkgs; [ nextcloud-client ];
        
        services.nextcloud-client = {
            enable = true;
            package = pkgs.nextcloud-client;
            startInBackground = true;
        };
        
    };

}
