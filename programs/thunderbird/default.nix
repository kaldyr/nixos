{
  pkgs,
  sysConfig,
  ...
}:
{
  home-manager.users.${sysConfig.user}.programs.thunderbird = {
    enable = true;

    policies = {
      ExtensionSettings = {
        "{dc507cf7-d933-5332-9907-d86324488dd8}" = {
          install_url = "https://raw.githubusercontent.com/catppuccin/thunderbird/0289f3bd9566f9666682f66a3355155c0d0563fc/themes/frappe/frappe-sapphire.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles.${sysConfig.user} = {
      isDefault = true;

      search = {
        force = true;
        default = "ddg";

        engines = {
          "bing".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
        };
      };

      settings = {
        "browser.display.use_document_fonts" = 0;
        "browser.download.dir" = "/home/${sysConfig.user}/Downloads/Mail";
        "browser.download.downloadDir" = "/home/${sysConfig.user}/Downloads/Mail";
        "browser.download.folderList" = 2;
        "browser.download.useDownloadDir" = true;
        "datareporting.healthreport.uploadEnabled" = false;
        "font.name.monospace.x-western" = "Maple Mono NF";
        "font.name.sans-serif.x-western" = "Recursive Sans Casual Static";
        "font.name.serif.x-western" = "Libertinus Serif";
        "layout.css.always_underline_links" = true;
        "mail.SpellCheckBeforeSend" = true;
        "mail.close_message_window.on_delete" = true;
        "mail.compose.add_link_preview" = true;
        "mail.spam.manualMark" = true;
        "mail.tabs.drawInTitlebar" = false;
        "mailnews.mark_message_read.delay" = true;
        "mailnews.mark_message_read.delay.interval" = 6;
        "mailnews.message_display.disable_remote_image" = false;
        "messenger.options.messagesStyle.variant" = "Dark";
        "network.trr.mode" = 5;
        "privacy.globalprivacycontrol.enabled" = true;
      };
    };
  };
}
