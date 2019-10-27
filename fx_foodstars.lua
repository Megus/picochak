function fx_foodstars()
set_palette({0x80, 0x85, 0x84, 4, 9, 10, 0x87, 7, 3, 0x8c, 0x84, 0x88})
px9_decomp(0, 64, 8903)

local angles, model, pcoords, scale, phalo, camerax, pfade, sprs, planets =
	{0.23, 0, 0}, 1, {}, 0, 0, 0, 0, {{48, 88}, {72, 88}, {0, 64}, {24, 64}, {48, 64}, {72, 64}, {0, 88}, {24, 88}}

local function draw_planet(p)
	pal(7, 8)
	pal(1, 9 + p[5])
	local p4 = p[4]
	sspr(sprs[p[6]][1], sprs[p[6]][2], 24, 24, p[2] - p4, p[3] - p4, p4 * 2, p4 * 2)
	pal(7, 7)
	pal(1, 1)
end

local function draw_orbit(phase)
	for c = 1, #planets do
		local oldx, oldy
		for d = 0, 15 do
			local x, y = s3d((d + phase) / 30, planets[c][1], scale, 0)
			if (oldx ~= nil) line(oldx, oldy, x, y, 0x1109.a5a5)
			oldx, oldy = x, y
		end
	end
end

return function()
	for c = 1, 3 do
		model, pfade = c, 0
		stars_set_mode(2, 2)
		wait_frames(15)

		planets = {}
		for c = 65, 125, 20 do
			add(planets, {c, rnd(), flr(rnd(4)), rndp(5, 5), rndp(0.005, 0.002)})
		end

		while loop_frames(90) do
			stars_set_mode(2, dease_elastic(frame, 12, 90))
			scale = sease_elastic(frame, 100, 90)
		end

		stars_set_mode(1)
		spr_text_show()
		pico_text_show()
		spr_text_hide()

		pfade = 1
		while loop_frames(30) do
			stars_set_mode(2, 2)
			scale, camerax = 600 - scos(frame, 500, 120), frame * frame / 4
		end

		pfade, camerax, scale = 2, 0, 0
		wait_frames(15)
	end
end,

function()
	stars_update()

	phalo += 0.01
	angles[1] += 0.005
	angles[2] += 0.003
	angles[3] += 0.001

	for planet in all(planets) do
		planet[2] -= planet[5]
	end
end,

function()
	stars_draw()

	if scale ~= 0 then
		camera(camerax, 0)

		for c = 1, #planets do
			local planet = planets[c]
			local x, y, z = s3d(planet[2], planet[1], scale, 0)
			pcoords[c] = {z, x, y, planet[4] * scale / z, planet[3], band(planet[2] * 8 + 1, 0x7) + 1}
		end

		draw_orbit(15)

		for planet in all(pcoords) do
			if (planet[1] >= 200) draw_planet(planet)
		end

		circfill(64, 64, scale * (0.325 + ssin(phalo, 0.025)), 0x1107.7fdf)
		circfill(64, 64, scale * (0.25 + ssin(phalo, 0.05, 0.83)), 0x1107.5f5f)

		m3d_shaded(m_vertices[model], m_tris[model], angles, scale, {0, 0, 400})

		draw_orbit(0)

		for planet in all(pcoords) do
			if (planet[1] < 200) draw_planet(planet)
		end

		camera()
	end

	if pfade == 1 and frame > 10 then
		circfill(104 - frame * 4, 64, frame * 9 - 90, 0x110f)
	elseif pfade == 2 then
		rectfill(0, 0, 128, 128, 0x10f + dither[frame + 1])
	end
end
end