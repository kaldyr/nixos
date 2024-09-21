{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ waypaper ];

        xdg.configFile."waypaper/config.ini".text = /* ini */ ''
            [Settings]
            language = en
            folder = ~/Pictures/Wallpapers
            monitors = All
            wallpaper = ~/Pictures/Wallpapers/mountain.jpg
            backend = swww
            fill = fill
            sort = name
            color = #303446
            subfolders = True
            show_hidden = False
            show_gifs_only = False
            post_command = 
            number_of_columns = 3
            swww_transition_type = simple
            swww_transition_step = 90
            swww_transition_angle = 0
            swww_transition_duration = 2
            swww_transition_fps = 60
            use_xdg_state = False
        '';

    };

}
