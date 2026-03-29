return {

	"MunsMan/kitty-navigator.nvim",

	keys = {
		{
			"<A-h>",
			function()
				require("kitty-navigator").navigateLeft()
			end,
			desc = "Focus window left",
			mode = { "n"}
		},
		{
			"<A-j>",
			function()
				require("kitty-navigator").navigateDown()
			end,
			desc = "Focus window down",
			mode = { "n"}
		},
		{
			"<A-k>",
			function()
				require("kitty-navigator").navigateUp()
			end,
			desc = "Focus window up",
			mode = { "n"}
		},
		{
			"<A-l>",
			function()
				require("kitty-navigator").navigateRight()
			end,
			desc = "Focus window right",
			mode = { "n"}
		},
	},

}
