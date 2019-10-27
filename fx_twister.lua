function fx_twister()
local pa, px, ptx, aspd, alspd, pattern, colors, ystart, y1end, y2end, w1, w2, amp, condense =
{0, 0.4}, {0.1, 0.5}, 0, {0.015, 0.007}, {-0.001, 0.003}, 0x1000.5a5a, {0x45, 0x55, 0x56, 0x66, 0x67, 0x78, 0x88}, 0, 0, 0, 8, 8, 32, 0.001

chak_palette()

local function draw_twister(y, tt, tpx, w)
	local adder, sides = scos(tpx, amp) + 64, #colors
	for c = 1, sides do
		local x1, x2 = sin(tt) * w + adder, ssin(tt + (1 / sides), w) + adder
		if (x2 > x1) rectfill(x1, y, x2, y, colors[c] + pattern)
		tt += 1 / sides
	end
end

return function()
	while loop_frames(65) do
		amp, y1end, w1 = 5, frame * 2, 0.5
	end

	while loop_frames(240) do
		w1, amp, alspd[1] = 0.5 + min(frame / 12, 10), 5 + min(frame / 10, 30), -abs(ssin(frame, 0.005, 240))
	end

	while loop_frames(65) do
		y2end, w2 = frame * 2, 0.5
	end

	while loop_frames(240) do
		w2, alspd[2] = 0.5 + min(frame / 12, 10), -abs(ssin(frame, 0.005, 240))
	end

	while loop_sync() do
		alspd, condense = {-abs(ssin(frame, 0.007, 250)), -abs(ssin(frame, 0.006, 223))}, 0.006 - scos(frame, 0.005, 200)
	end

	while loop_frames(120) do
		w1 = 10 - min(frame / 12, 9.5)
		w2 = w1
	end

	while loop_frames(64) do
		ystart = min(128, frame * 2)
	end
end,

function()
	ptx += 0.01
	for c = 1, 2 do
		px[c] += 0.01
		pa[c] += aspd[c]
	end
end,

function()
	pattern = bxor(pattern, 0x0.ffff)
	local tpa, tpx = {pa[1], pa[2]}, {px[1], px[2]}
	for y = ystart, 127 do
		if band(tpx[1], 0x0.ffff) > 0.5 then
			if (y < y1end) draw_twister(y, tpa[1], tpx[1], w1)
			if (y < y2end) draw_twister(y, tpa[2], tpx[2], w2)
		else
			if (y < y2end) draw_twister(y, tpa[2], tpx[2], w2)
			if (y < y1end) draw_twister(y, tpa[1], tpx[1], w1)
		end

		for c = 1, 2 do
			tpx[c] -= condense
			tpa[c] += alspd[c]
		end
	end
end,
12
end
