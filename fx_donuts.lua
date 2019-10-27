function fx_donuts()
local donuty, donutx, show_mega, offy, angles, tunnel, tunnel_active, move_donuts, px, py, dscale =
	128, 0, false, 210, {0, 0, 0}, {}, false, false, 0, 0, 47

set_palette({128, 133, 132, 4, 9, 10, 7, 7, 9, 10, 11, 0})

local function show_tunnel()
	tunnel_active = true
	for c = 1, 8 do
		add(tunnel, {10, rnd(14)})
		wait_frames(10)
	end
	wait_sync()
	tunnel_active = false
end

return function()
	pico_text_show(false)
	wait_frames(60)
	show_tunnel()
	stars_set_mode(1)
	pico_text_hide()
	wait_frames(30)

	while loop_frames(64) do
		donuty -= 2
	end

	move_donuts, show_mega = true, true
	wait_frames(120)
	while loop_frames(210) do
		offy -= 1
	end
	wait_sync()
	move_donuts = false
	while loop_frames(64) do
		donuty += 3
	end

	spr_text_show()
	pico_text_show()
	pico_text_show()
	spr_text_hide()
	stars_set_mode(2, 2)
	wait_frames(30)
	show_tunnel()

	while loop_frames(15) do
		dscale += 10
	end
end,

function()
	stars_update()
	angles[1] += 0.005
	angles[2] += 0.007
	angles[3] += 0.002
	if move_donuts then
		donutx, donuty = ssin(px, 32) - 32, ssin(py, 32) - 32
		px += 0.005
		py += 0.007
	end

	for r in all(tunnel) do
		r[1] *= 1.12
		if r[1] > 80 and tunnel_active then
			r[1], r[2] = rndp(4, 8), rnd(14)
		end
	end
end,

function()
	stars_draw()

	for r in all(tunnel) do
		circ(64, 64, r[1], flr(r[2]) + 0x1001)
	end

	local y, f = donuty, 0

	while y < 128 do
		local x = donutx + f
		while x < 128 do
			spr(171, x, y, 2, 2)
			x += 32
		end
		y += 16
		f = bxor(f, 16)
	end

	if (show_mega) m3d_shaded(m_vertices[4], m_tris[4], angles, dscale, {0, offy, 200})
end
end