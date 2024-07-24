{ pkgs, ... }: {
    home.packages = with pkgs; [ libsixel ];

    programs.foot = {

        enable = true;

        settings = {

            colors = {
                foreground = "c6d0f5"; # Text #c6d0f5
                background = "303446"; # Base #303446
                regular0 = "51576d";  # Surface 1 #51576d
                regular1 = "e78284";  # red #e78284
                regular2 = "a6d189";  # green #a6d189
                regular3 = "e5c890";  # yellow #e5c890
                regular4 = "8caaee";  # blue #8caaee
                regular5 = "f4b8e4";  # pink #f4b8e4
                regular6 = "81c8be";  # teal #81c8be
                regular7 = "b5bfe2";  # Subtext 1 #b5bfe2
                bright0 = "626880";  # Surface 2 #626880
                bright1 = "e78284";  # red #e78284
                bright2 = "a6d189";  # green #a6d189
                bright3 = "e5c890";  # yellow #e5c890
                bright4 = "8caaee";  # blue #8caaee
                bright5 = "f4b8e4";  # pink #f4b8e4
                bright6 = "81c8be";  # teal #81c8be
                bright7 = "a5adce";  # Subtext 0 #a5adce
            };

            cursor.style = "beam";
            cursor.beam-thickness = 1;

            key-bindings.show-urls-launch = "Control+Shift+u";
            key-bindings.unicode-input = "Control+Shift+i";

            main = {
                box-drawings-uses-font-glyphs = "yes";
                font = "Recursive Mn Csl St:size=10, Noto Color Emoji:size=10, Symbols Nerd Font:size=10";
                font-bold = "Recursive Mn Csl St:size=10:style=Bold";
                font-italic = "Recursive Mn Csl St:size=10:style=Italic";
                font-bold-italic = "Recursive Mn Csl St:size=10:style=Bold Italic";
                selection-target = "primary";
            };

            scrollback = {
                lines = 10000;
                multiplier = 5;
            };

            url = {
                launch = "xdg-open \${url}";
                label-letters = "sadfjklewcmpgh";
                osc8-underline = "url-mode";
                protocols = "http, https, ftp, ftps, file, gemini, gopher, irc, ircs";
                uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?@!$&%*+=\"'()[]";
            };

        };

    };

    xdg.desktopEntries = {
        "org.codeberg.dnkl.footclient" = { name = "Foot Client"; noDisplay = true; };
        "org.codeberg.dnkl.foot-server" = { name = "Foot Server"; noDisplay = true; };
    };

}
