{ lib, sysConfig, ... }: {

    environment.persistence = lib.mkIf sysConfig.impermanence {
        "/state".users.${sysConfig.user}.directories = [
            ".config/newsboat"
            ".local/share/newsboat"
        ];
    };

    home-manager.users.${sysConfig.user}.programs.newsboat = {

        enable = true;

        extraConfig = /* ini */ ''
            auto-reload yes
            reload-threads 8
            reload-time 30
            prepopulate-query-feeds yes

            # dont keep a search history
            history-limit 0

            bind-key j down
            bind-key k up
            bind-key j next articlelist
            bind-key k prev articlelist
            bind-key J next-feed articlelist
            bind-key K prev-feed articlelist
            bind-key G end
            bind-key g home
            bind-key d pagedown
            bind-key u pageup
            bind-key l open
            bind-key h quit
            bind-key a toggle-article-read
            bind-key n next-unread
            bind-key N prev-unread
            bind-key D pb-download
            bind-key U show-urls
            bind-key x pb-delete
        '';

    };

}
