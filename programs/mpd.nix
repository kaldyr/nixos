{ pkgs, sysConfig, ... }: {

    environment.persistence."/state".users.${sysConfig.user}.directories = [
        { directory = ".local/share/mpd"; mode = "0700"; }
    ];

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [
            mpd
            mpdris2
            mpc-cli
        ];

        programs.ncmpcpp.enable = true;

        services.mpd = {
            
            enable = true;
            
            extraConfig = /* bash */ ''
                audio_output {
                    type "pipewire"
                    name "pipewire"
                }

                audio_output {
                    type "fifo"
                    name "visualizer"
                    path "/tmp/mpd.fifo"
                    format "44100:16:1"
                }
            '';

            musicDirectory = "~/Music";
            network.startWhenNeeded = true;

        };

        services.mpdris2 = {
            enable = true;
            mpd.musicDirectory = "/home/${sysConfig.user}/Music";
            notifications = true;
        };

        xdg.configFile."ncmpcpp/bindings".text = /* bash */ ''
            def_key "h"
              previous_column
            def_key "j"
              scroll_down
            def_key "k"
              scroll_up
            def_key "l"
              next_column
        '';

    };

}
