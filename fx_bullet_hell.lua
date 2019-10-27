function fx_bullet_hell()
local bullets, sprs, ptn, donuts, heroes, sprn = {}, {141, 139, 108}, 17, {}, {}

set_palette({1, 2, 3, 4, 9, 10, 135, 7, 9, 10, 8, 0})
stars_set_mode(3, -1)
init_blows()

local function donut_xy(a)
	return 190 - scos(a, 100), 72 + ssin(a, 100)
end

return function()
	wait_frames(17)
	for c = 1, 3 do
		sprn = c
		init_blows()
		for d = 0, 1, 0.025 do
			add(donuts, d)
		end

		for d = 0, 127, 16 do
			add(heroes, {0, d})
		end

		while loop_frames(255) do
			if rnd() < 0.4 + c * 0.1 then
				local x, y = donut_xy(rnd_arr(donuts))
				if c == 1 then
					for d = -1, 1 do
						for e = 0, 3, 3 do add(bullets, {x, y, 1, 10, 2, d, e}) end
					end
				else
					for a = -0.125, 0.125, 0.05 do
						for d = 0, c do add(bullets, {x, y, c - 1, 11, scos(a, 2), ssin(a, 2), d * 5}) end
					end
				end
			end
			local h = rnd_arr(heroes)
			add(bullets, {h[1], h[2] + 8, 2, 6, -3, 0, 0})

			if rnd() < 0.02 and #heroes ~= 1 then
				local h = rnd_arr(heroes)
				blows_add(h[1] + 8, h[2] + 8)
				del(heroes, h)
			end

			if rnd() < 0.1 and #donuts ~= 1 then
				local d = rnd_arr(donuts)
				local x, y = donut_xy(d)
				blows_add(x + 8, y)
				del(donuts, d)
			end

			if (frame == 239) ptn = 17
		end
		donuts, heroes, bullets = {}, {}, {}
	end
	init_blows()
	wait_frames(60)
end,

function()
	stars_update()
	blows_update()

	for b in all(bullets) do
		if b[7] == 0 then
			b[1] -= b[5]
			b[2] += b[6]
			if (out_of_screen(b)) del(bullets, b)
		else
			b[7] -= 1
		end
	end

	for c = 1, #donuts do
		donuts[c] += 0.003
	end

	for h in all(heroes) do
		h[1] += 0.1
	end

	ptn = max(-17, ptn - 1)
end,

function()
	stars_draw()

	for b in all(bullets) do
		if b[7] == 0 then
			circfill(b[1], b[2], b[3] + 1, 14)
			circfill(b[1], b[2], b[3], b[4])
		end
	end

	for d in all(donuts) do
		local x, y = donut_xy(d)
		spr(171, x, y - 8, 2, 2)
	end

	for h in all(heroes) do
		spr(sprs[sprn], h[1], h[2], 2, 2)
	end

	blows_draw()
	rectfill(0, 0, 127, 127, 0x10f + dither[max(1, abs(ptn))])
end
end