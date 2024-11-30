{ sysConfig, ... }: {

	environment.persistence."/state".users.${sysConfig.user}.directories = [ ".local/state/lazygit" ];

	home-manager.users.${sysConfig.user} = {

		programs.lazygit.enable = true;

		xdg.configFile."lazygit/config.yml".text = /* yaml */ ''
gui:
  theme:
    activeBorderColor:
      - '#85c1dc'
      - bold
    cherryPickedCommitBgColor:
      - '#51576d'
    cherryPickedCommitFgColor:
      - '#85c1dc'
    defaultFgColor:
      - '#c6d0f5'
    inactiveBorderColor:
      - '#a5adce'
    optionsTextColor:
      - '#8caaee'
    searchingActiveBorderColor:
      - '#e5c890'
    selectedLineBgColor:
      - '#414559'
    selectedRangeBgColor:
      - '#414559'
    unstagedChangesColor:
      - '#e78284'
'';
	};

}
