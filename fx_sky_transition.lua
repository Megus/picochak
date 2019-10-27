function fx_sky_transition()
local y = (sky_dir == -1) and 128 or -64

stars_palette()
stars_set_mode(3, 0, sky_dir)

return function()
	wait_frames(60)
	sky_dir *= -1
end,

function()
	stars_update()
	y += sky_dir * 3.2
end,

function()
	stars_draw()
	draw_gradient(y, 0xc0)
end
end