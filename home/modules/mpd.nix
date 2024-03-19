{ pkgs, ... }: {

    home.packages = with pkgs; [
        mpd
        mpc-cli
    ];

    programs.ncmpcpp = {
        enable = true;
        bindings = [
            { key = "h"; command = "previous_column"; }
            { key = "j"; command = "scroll_down"; }
            { key = "k"; command = "scroll_up"; }
            { key = "l"; command = "next_column"; }
        ];
        mpdMusicDir = "~/Music";
    };

    services.mpd = {
        enable = true;
        extraConfig = ''
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

}
