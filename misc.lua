function rnd_arr(arr)
	return arr[flr(rnd(#arr)) + 1]
end

function rndp(r, a)
	return rnd(r) + a
end

function s3d(a, r, scale, yscale)
	local x, z = scos(a, r), ssin(a, r) + 200
	return 64 + scale * x / z, 60 + scale * ((x * yscale + 60) / z - 0.3), z
end

function draw_gradient(y, cols)
	local ptn = 1
	while y < 128 do
		rectfill(0, y, 127, y + 3, cols + dither[ptn])
		y += 4
		ptn = min(ptn + 1, 17)
	end
end

function set_palette(palette)
	for i = 1, #palette do pal(i, palette[i], 1) end
	stars_palette()
end

function chak_palette()
	set_palette({128, 133, 132, 4, 9, 10, 135, 7, 7, 7, 11, 12})
end

function stars_palette()
	pal(13, 1, 1)
	pal(14, 6, 1)
	pal(15, 7, 1)
end

function ssin(t, scale, tscale)
	return sin(t / (tscale or 1)) * scale
end

function scos(t, scale, tscale)
	return cos(t / (tscale or 1)) * scale
end

function sease_elastic(t, scale, tscale, p)
	p, scale = p or 0.3, scale or 1
	t /= tscale or 1
	return scale * (2 ^ (-10 * t)) * -sin((t - p / 4) / p) + scale
end

function sease_cubic(t, scale, tscale)
	scale = scale or 1
	t /= tscale or 1
	if (t < 0.5) return scale * (t * 2) ^ 3 / 2
	return scale - scale * ((1 - t) * 2) ^ 3 / 2
end

function dease_cubic(t, scale, tscale)
	return sease_cubic(t, scale, tscale) - sease_cubic(t - 1, scale, tscale)
end

function dease_elastic(t, scale, tscale)
	return sease_elastic(t, scale, tscale) - sease_elastic(t - 1, scale, tscale)
end

function out_of_screen(o)
	return band(o[1], 0xff80) ~= 0 or band(o[2], 0xff80) ~= 0
end
