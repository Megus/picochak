function fx_final_strike()
local offx, hero, shake, pa1, pa2, rblow, dblow, rayx1, rayx2 = 0, 1, false, 0, 0, 0, 0, -1000, -1000

chak_palette()
init_blows()

local function model_move(frames, x, distance, stars_scale, ease, dease)
	while loop_frames(frames) do
		offx = ease(frame, distance, frames) + x
		stars_set_mode(3, dease(frame, stars_scale, 54))
	end
	stars_set_mode(1)
end

local function hero_phrase(h, x11, x12, x21, x22, ss)
	spr_text_show()
	pico_text_show(false)
	hero = h
	model_move(54, x11, x12, 3 * ss, sease_elastic, dease_elastic)

	wait_frames(55)

	spr_text_hide()
	pico_text_hide()
	model_move(27, x21, x22, -12 * ss, sease_cubic, dease_cubic)
end

local function rnd_blow()
	local r, a = rndp(15, 15), rnd()
	blows_add(64 + ssin(a, r), 64 + scos(a, r))
end

return function()
	for c = 1, 3 do
		hero_phrase(1, -150, 150, 0, -225, 1)
		hero_phrase(2, 150, -150, 0, 225, -1)
	end

	shake, hero = true, 1
	model_move(60, -150, 150, 3, sease_elastic, dease_elastic)
	dblow = 0.5
	wait_frames(120)
	dblow, rayx1, rayx2 = 0, 64, 128
	wait_frames(60)

	model_move(30, 0, -200, -12, sease_cubic, dease_cubic)
	hero, rayx1, rblow = 2, -1000, 0
	model_move(60, 150, -150, -3, sease_elastic, dease_elastic)
	wait_frames(30)
	rayx1, rayx2 = -1000, -1000

	for c = 1, 90 do
		for d = 1, 4 do
			rnd_blow()
		end
		wait_frames(1)
	end

	hero = 0
	for c = 1, 20 do
		rnd_blow()
		wait_frames(2)
	end
	shake = false

	pico_text_show()
end,

function()
	pa1 += 0.005
	pa2 += 0.003
	rblow += dblow

	stars_update()
	blows_update()
end,

function()
	if (shake) camera(rndp(4, -2), rndp(4, -2))
	stars_draw()

	rectfill(rayx1 + offx, 40, rayx2, 88, 8)
	if (rblow ~= 0) draw_blow(64 + offx, 64, rblow)

	local angles, offsets = {ssin(pa1, 0.1) + 0.05, scos(pa2, 0.1), 0}, {offx, 0, 200}
	if hero == 1 then
		m3d_tex(m_vertices[5], m_tris[5], angles, 110, offsets)
	elseif hero == 2 then
		m3d_shaded(m_vertices[4], m_tris[4], angles, 44, offsets)
	end

	blows_draw()
end
end