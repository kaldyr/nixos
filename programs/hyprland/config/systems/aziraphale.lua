hl.monitor({
	output   = 'desc:BOE 0x0DC1',
	mode     = '1920x1200@60',
	position = 'auto',
	scale    = '1.0',
})

hl.config({ general = {
	gaps_in  = { top = 8, left = 12, right = 12, bottom = 9 }, -- 5
	gaps_out = { top = 1, left = 18, right = 18, bottom = 18 }, -- 20
} })
