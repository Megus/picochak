function fx_preparations(sprnum, dpx, dpy, final)
local ppx, ppy, starty, particles, sm, pgrad, grady, bugx, bstate = 0, 0, 56, {}, 0, 128, 128, 0, 0

for c = 1, 24 do
	particles[c] = {0, 0, 0, rndp(60, 30), 0, 0, rnd(), rnd()}
end

local function new_particle(c, p4, p7, p8)
	local p = particles[c]
	particles[c] = {p[1], p[2], 0, p4, p[1], p[2], p7, p8}
end

local function move_particles()
	for c = 1, #particles do
		local p = particles[c]
		local p3, p4, p5, p6 = p[3], p[4], p[5], p[6]
		local ease = sease_cubic(p3, 1, p4)
		p[1] = p5 + ease * (p[7] - p5)
		p[2] = p6 + ease * (p[8] - p6)
		p[3] += 1
		if p3 >= p4 then
			new_particle(c, rndp(30, 30), rnd(), rnd())
		end
	end
end

return function()
	while loop_frames(240) do
		move_particles()
	end

	for c = 1, #particles do
		new_particle(c, 60, c / #particles, 0.9)
	end
	dpy, bstate = (ppx + dpx * 60 - ppy) / 60, 1

	while loop_frames(60) do
		bugx = 128 - sease_elastic(frame, 64, 60)
		move_particles()
	end

	bstate, dpx, dpy = 2, 0.01, 0.01
	wait_sync()

	bstate = 3
	if final == true then
		ppx, ppy = band(ppx, 0x0.ffff), band(ppy, 0x0.ffff)
		dpx, dpy = -ppx / 120, -ppy / 120
		for c = 1, #particles do
			new_particle(c, 120, rndp(0.14, 0.68), rndp(0.7, 0.3))
		end

		while loop_frames(120) do
			bugx = 64 - sease_cubic(frame, 128, 60)
			move_particles()
		end

		while loop_frames(90) do
			starty, dpx, dpy = 56 + frame / 1.1, 0, 0
			grady += 2
		end
	else
		while loop_frames(90) do
			bugx, starty = 64 - sease_cubic(frame, 128, 60), 56 - sease_cubic(frame, 140, 90)
		end
	end
end,

function()
	ppx += dpx
	ppy += dpy
	pgrad += 0.005
	grady = max(80, grady - 1)
end,

function()
	local cnt = (bstate == 2) and min(flr(frame / 1.3), 24) or 24

	local function draw_bugulma()
		palt(12, true)
		palt(0, false)
		spr(128, bugx - 29, 32, 9, 8)
		if bstate ~= 1 then
			spr_print(bugx - (cnt < 10 and 4 or 8), 72, "" .. cnt)
			rectfill(bugx - 16, 83, bugx - 16 + min(cnt * 1.33, 31), 86, 0x1008)
		end
		palt()
	end

	draw_gradient(grady + ssin(pgrad, 10), 0xfc)

	if (bstate % 2 == 1) draw_bugulma()
	pal(12, 0)
	for c = 1, #particles do
		local p = particles[c]
		local x, y = 56 + scos(p[1] + ssin(ppx, 0.128), p[2] * 64), starty + ssin(p[1] + ssin(ppy, 0.125), p[2] * 64)
		if bstate == 2 and c <= cnt then
			line(64, 64, x + 8, y + 8, 0x1105.5a5a)
		end
		spr(sprnum, x, y, 2, 2)
	end
	pal()

	if (bstate == 2) draw_bugulma()
end,

12
end
