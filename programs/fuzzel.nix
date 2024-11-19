{ sysConfig, ... }: {

    environment.persistence."/nix".users.${sysConfig.user}.files = [ ".cache/fuzzel" ];

    home-manager.users.${sysConfig.user} = {

        programs.fuzzel.enable = true;

        xdg.configFile."fuzzel/fuzzel.ini".text = /* ini */ ''
            [colors]
            background=303446e6
            border=babbf1ff
            match=81c8beff
            selection-match=81c8beff
            selection-text=c6d0f5ff
            selection=626880ff
            text=c6d0f5ff

            [main]
            filter-desktop=true
            font=Recursive Sn Csl St:size=10
            icon-theme=Papirus
            icons-enabled=yes
            image-size-ratio=1.0
            inner-pad=8
            layer=overlay
            letter-spacing=0
            line-height=24
            lines=10
            match-mode=fzf
            prompt="❄️ ❯ "
            terminal=foot
            width=60
        '';

    };

}
