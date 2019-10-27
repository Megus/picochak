function fx_donut_attack()
local bg, bgc, lasers, donuts = 0, 0, {}, {}

stars_palette()
init_galaxy()

local function random_line(t)
	local a1, a2 = rnd(), rnd()
	add(t, {ssin(a1, 120) + 64, scos(a1, 120) + 64, ssin(a2, 120) + 64, scos(a2, 120) + 64, 20})
end

return function()
	while loop_sync() do
		if (rnd() < 0.4) random_line(lasers)
		if (rnd() < 0.7) random_line(donuts)
		if (rnd() < 0.1) galaxy_blow_star()
	end

	bgc = 1000
	pico_text_show()
end,

function()
	stars_update()
	galaxy_update()

	if (bgc <= 0) bgc = rnd(20) + 10
	bg = bgc < 10 and (flr(bgc % 2) * 2) or 0
	bgc -= 0.4

	for l in all(lasers) do
		l[5] -= 1
		if (l[5] == 0) del(lasers, l)
	end

	for d in all(donuts) do
		d[1] += (d[3] - d[1]) * 0.05
		d[2] += (d[4] - d[2]) * 0.05
		if (abs(d[3] - d[1]) < 1 and abs(d[4] - d[2]) < 1) del(donuts, d)
	end
end,

function()
	cls(bg)
	stars_draw()
	galaxy_draw()

	for l in all(lasers) do
		local x1, y1, x2, y2 = l[1] + rnd(2), l[2] + rnd(2), l[3] + rnd(2), l[4] + rnd(2)
		line(x1 + 3, y1, x2 + 3, y2, 0x1102)
		line(x1, y1, x2, y2, 0x1107 + rnd())
		line(x1 + 1, y1, x2 + 1, y2, 0x110a + rnd())
	end

	pal(12, 0)
	for donut in all(donuts) do
		spr(171, donut[1], donut[2], 2, 2)
	end
end,

-1
end