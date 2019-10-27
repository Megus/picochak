function fx_picochak()
local angles, offsets, rotate = {0, 0, 0}, {0, -300, 300}, false
chak_palette()

return function()
	while loop_frames(180) do
		local ease = sease_cubic(frame, 1, 180)
		stars_set_mode(3, 0, 1 - ease)
		offsets[2] = ease * 300 - 300
	end

	stars_set_mode(1)
	pico_text_show(false)

	rotate = true
	wait_sync()

	pico_text_hide()
	while loop_frames(104) do
		local ease = sease_cubic(frame, 1, -104)
		stars_set_mode(3, ease)
		offsets[1] = ease * 150
	end
end,

function()
	stars_update()
	if rotate then
		angles[1] += 0.006
		angles[2] += 0.003
		angles[3] += 0.002
	end
end,

function()
	stars_draw()
	m3d_tex(m_vertices[5], m_tris[5], angles, 150, offsets)
end
end