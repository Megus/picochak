function fx_epilogue()
poke4(0x5f40, 0x2.080f)
music(0x2d)
chak_palette()

local px, py, bumpmap, idx, txty, notdone, text = 0, 0, {}, 1, 115, true,
	{'p i c o c h a k', 'pico-8 demo', 'by megus and stardust', '', 'code', 'megus', '', 'music', 'n1k-o / stardust', '', 'graphics', 'diver / stardust', '', 'presented at', 'cafe 2019', '', 'no donuts were eaten', 'in the making of this demo', '', '', 'thank you for watching!'}

for y = -16, 15 do
	for x = -16, 15 do
		add(bumpmap, 4 * max(0, 24 - flr(sqrt(x * x + y * y))))
	end
end

return function()
	while notdone do yield() end
	music(-1, 8000)
	for c = 1, 96 do
		for d = 1, #bumpmap do
			bumpmap[d] = max(0, bumpmap[d] - 1)
		end
		wait_frames(3)
	end
	stop()
end,

function()
	px += 0.0057
	py += 0.007

	if notdone then
		if txty < -24 then
			txty += 16
			idx += 1
			if (idx > #text) notdone = false
		else
			txty -= 0.5
		end
	end
end,

function()
	local lightx, ly = flr(ssin(px, 22) - 16), flr(scos(py, 22) - 16)
	for y = 1, 63 do
		local lx = lightx
		for x = 1, 63 do
			local xdelta, ydelta = sget(x - 1, y) - sget(x + 1, y), sget(x, y - 1) - sget(x, y + 1)
			local xtemp, ytemp = lx + xdelta * 2, ly + ydelta * 2
			if band(xtemp, 0xffe0) == 0 and band(ytemp, 0xffe0) == 0 then
				rectfill(x * 2, y * 2, x * 2 + 1, y * 2 + 1, colormap[bumpmap[ytemp * 32 + xtemp + 1]])
			end
			lx += 1
		end
		ly += 1
	end

	if notdone then
		local ty, tidx = txty, idx
		while ty < 115 and tidx <= #text do
			local str = text[tidx]
			pico_print(64 - #str * 2, ty, str, 8)

			ty += 16
			tidx += 1
		end
	end
end
end