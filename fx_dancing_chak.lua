function fx_dancing_chak()
local angle, balls, rings, y1, y2, hl, p, t1, t2 = 0, {}, -4, 96, 80, 0, -1, {32, 64, 80, 96, 250}, {96, 127, 16, 32, 64}
stars_palette()

return function()
	while loop_frames(1268) do
		if frame % 32 == 0 then
			for c = 1, 8 do
				add(balls, {rnd(128), rnd(128), rndp(10, 8), flr(rndp(8, 0x107)), 0.75})
			end
			rings = min(5, rings + 1)
		end

		if rings == 5 then
			if frame % 128 == 0 then
				p = (p + 1) % 4
				hl = p == 3 and 2 or 0
				if (p == 3 or p == 0) y1, y2 = y2, y1
			end

			local t = (p == 3) and t2[hl + 1] or t1[hl + 1]
			if (frame % 128 >= t) hl = (hl + 1) % 5
		end
	end
end,

function()
	stars_update()
	angle += 0.005

	for b in all(balls) do
		b[5] += 0.25
		if (b[5] == 17) del(balls, b)
	end
end,

function()
	stars_draw()
	pal(12, 12)
	for b in all(balls) do
		circfill(b[1], b[2], b[3], b[4] + dither[flr(b[5])])
	end

	pal(12, 0)
	local jumpy = abs(ssin(frame, 8, 64))
	for i = 0, 0.9, 0.1 do
		for j = 1, rings do
			local a = angle + i + ssin(j, ssin(frame, 0.03, 64), 4)
			spr(173, 56 + ssin(a, j * 10), 60 + scos(a, j * 10) - jumpy, 2, 2)
		end
	end

	local function kprint(x, y, text, n)
		spr_print(x, y - jumpy, text, hl == n and 11)
	end

	if rings == 5 then
		kprint(12, y1, "dance!", 0)
		kprint(68, y1, "dance!", 1)
		kprint(28, y2, "pico", 2)
		kprint(44, y2, "co", 3)
		kprint(60, y2, "chak!", 4)
	end

end
end
