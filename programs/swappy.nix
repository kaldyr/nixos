{ pkgs, sysConfig, ... }: {

	home-manager.users.${sysConfig.user} = {

		home.packages = with pkgs; [ swappy ];

		xdg.configFile."swappy/config".text = /* ini */ ''
			[Default]
			save_dir=$HOME/Pictures/Screenshots
			save_filename_format=%Y%m%d%H%M%S.png
			show_panel=false
			line_size=4
			text_size=16
			text_font=Recursive Sans Casual Static
			paint_mode=brush
			early_exit=false
			fill_shape=false
		'';

	};

}
