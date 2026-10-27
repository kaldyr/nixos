{
  pkgs,
  sysConfig,
  ...
}:
{
  fonts = {
    enableDefaultPackages = false;

    fontconfig = {
      antialias = true;

      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Maple Mono NF"
          "Liga Rec Mono Custom"
          "JuliaMono"
          "Noto Sans Mono CJK HK"
          "Noto Sans Mono CJK JP"
          "Noto Sans Mono CJK KR"
          "Noto Sans Mono CJK SC"
          "Noto Sans Mono CJK TC"
        ];
        sansSerif = [
          "Recursive Sans Casual Static"
          "Inter"
          "Liberation Sans"
          "Noto Color Emoji"
          "Noto Sans CJK HK"
          "Noto Sans CJK JP"
          "Noto Sans CJK KR"
          "Noto Sans CJK SC"
          "Noto Sans CJK TC"
        ];
        serif = [
          "Libertinus Serif"
          "Liberation Serif"
          "Noto Serif CJK HK"
          "Noto Serif CJK JP"
          "Noto Serif CJK KR"
          "Noto Serif CJK SC"
          "Noto Serif CJK TC"
        ];
      };

      hinting.enable = true;

      localConf = /* xml */ ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
            <dir>/state/fonts</dir>
            <match target="font">
                <test qual="any" name="family" compare="contains"><string>Inter</string></test>
                <!-- https://rsms.me/inter/#features -->
                <edit name="fontfeatures" mode="assign_replace">
                    <string>calt</string> <!-- Contextural alternatives -->
                    <string>case</string> <!-- Case alternates -->
                    <string>ccmp</string> <!-- Compositions -->
                    <string>cv02</string> <!-- Open four -->
                    <string>cv03</string> <!-- Open six -->
                    <string>cv04</string> <!-- Open nine -->
                    <string>cv05</string> <!-- Lower case L with tail -->
                    <string>cv06</string> <!-- Simplified U -->
                    <string>cv08</string> <!-- Upper case i with serif -->
                    <string>ss03</string> <!-- Round quotes & commas -->
                    <string>tnum</string> <!-- Tabular numbers -->
                    <string>zero</string> <!-- Slashed zero -->
                </edit>
            </match>
            <match target="font">
                <test qual="any" name="family" compare="contains"><string>Recursive</string></test>
                <!-- https://github.com/arrowtype/recursive#opentype-features -->
                <edit name="fontfeatures" mode="assign_replace">
                    <string>ss20</string>
                    <string>case</string>
                    <string>liga</string>
                </edit>
            </match>
        </fontconfig>
      '';

      subpixel.rgba = "rgb";
      subpixel.lcdfilter = "default";
    };

    packages = with pkgs; [
      font-awesome # Symbols
      inter # Sans Font
      julia-mono # Math font
      liberation_ttf # Open versions of MS fonts
      libertinus # System Serif Font and Math
      maple-mono-custom # Mono Font
      noto-fonts-cjk-sans # Display of Chinese/Japanese/Korean characters
      noto-fonts-cjk-serif # Display of Chinese/Japanese/Korean characters
      noto-fonts-color-emoji # Symbols
      recursive # System sans font
    ];
  };

  home-manager.users.${sysConfig.user} = {
    fonts.fontconfig.enable = true;
  };

}
