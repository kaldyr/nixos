{ pkgs, sysConfig, ... }: {

    home-manager.users.${sysConfig.user} = {

        home.packages = with pkgs; [ libsixel ];

        programs.foot.enable = true;

        xdg = {

            configFile."foot/foot.ini".text = /* ini */ ''
                [colors]
                background=303446
                bright0=626880
                bright1=e78284
                bright2=a6d189
                bright3=e5c890
                bright4=8caaee
                bright5=f4b8e4
                bright6=81c8be
                bright7=a5adce
                foreground=c6d0f5
                regular0=51576d
                regular1=e78284
                regular2=a6d189
                regular3=e5c890
                regular4=8caaee
                regular5=f4b8e4
                regular6=81c8be
                regular7=b5bfe2

                [cursor]
                beam-thickness=1
                style=beam

                [key-bindings]
                show-urls-launch=Control+Shift+u
                unicode-input=Control+Shift+i

                [main]
                box-drawings-uses-font-glyphs=yes
                font=Recursive Mn Csl St:size=10, Noto Color Emoji:size=10, Symbols Nerd Font:size=10
                font-bold=Recursive Mn Csl St:size=10:style=Bold
                font-bold-italic=Recursive Mn Csl St:size=10:style=Bold Italic
                font-italic=Recursive Mn Csl St:size=10:style=Italic
                line-height=11.600000
                selection-target=primary

                [scrollback]
                lines=10000
                multiplier=5

                [url]
                label-letters=sadfjklewcmpgh
                launch=xdg-open ''\'''${url}'
                osc8-underline=url-mode
                protocols=http, https, ftp, ftps, file, gemini, gopher, irc, ircs
                uri-characters=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?@!$&%*+="'()[]
            '';

            desktopEntries = {
                "org.codeberg.dnkl.footclient" = { name = "Foot Client"; noDisplay = true; };
                "org.codeberg.dnkl.foot-server" = { name = "Foot Server"; noDisplay = true; };
            };

        };

    };

}
