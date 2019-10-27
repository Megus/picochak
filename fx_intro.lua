function fx_intro()
local plogo = 0

px9_decomp(0, 64, 0x2000)
stars_palette()
init_galaxy()

return function()
	pico_text_show()

	spr_text_show()
	while loop_frames(90) do
		plogo = sease_elastic(frame, 96, 90)
	end

	wait_frames(60)

	spr_text_hide()
	while loop_frames(165) do
		plogo = scos(min(frame, 45), 96, 180)
		galaxy_set_scale(120 + frame * 3)
		galaxy_delete_star()
		galaxy_delete_star()
		stars_set_mode(2, min(frame / 125, 2))
	end
end,

function()
	stars_update()
	galaxy_update()
end,

function()
	stars_draw()
	galaxy_draw()
	spr(128, 14, 128 - plogo, 13, 8)
end
end