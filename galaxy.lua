function init_galaxy()
local galaxy, colors, blows, scale = {}, {1, 6, 7, 10, 15}, {}, 120

for c = 1, 5 do
	for d = 1, 100 do
		add(galaxy, {d + rnd(), rndp(0.1, c / 5 + d / 100), rnd_arr(colors)})
	end
end

function galaxy_set_scale(nscale)
	scale = nscale
end

function galaxy_delete_star()
	del(galaxy, rnd_arr(galaxy))
end

function galaxy_blow_star()
	local star = del(galaxy, rnd_arr(galaxy))
	local x, y = s3d(star[2], star[1], scale, 0.33)
	add(blows, {x, y, 1})
end

function galaxy_update()
	for s in all(galaxy) do
		s[2] -= 0.001
	end
	for b in all(blows) do
		b[3] += 0.3
		if (b[3] > 10) del(blows, b)
	end
end

function galaxy_draw()
	for s in all(galaxy) do
		local x, y = s3d(s[2], s[1], scale, 0.33)
		pset(x, y, s[3])
	end

	for b in all(blows) do
		circfill(b[1], b[2], b[3], 0x107 + dither[flr(b[3] * 1.5)])
	end
end
end