{ sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        programs.cava.enable = true;

        xdg.configFile."cava/config".text = /* ini */ ''
            [color]
            gradient = 1
            gradient_color_1='#81c8be'
            gradient_color_2='#99d1db'
            gradient_color_3='#85c1dc'
            gradient_color_4='#8caaee'
            gradient_color_5='#ca9ee6'
            gradient_color_6='#f4b8e4'
            gradient_color_7='#ea999c'
            gradient_color_8='#e78284'
            gradient_count = 8
            
            [general]
            bar_width=1

            [smoothing]
            noise_reduction = 15
        '';

    };

}
