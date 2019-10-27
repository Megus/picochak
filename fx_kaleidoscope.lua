function fx_kaleidoscope()
local zph, zzoom, zpx, zpy = 0, 1, 0, 0
px9_decomp(0, 0, 11008)

return function()
	for c = 1, 8 do
		spr_text_show(15)
		wait_frames(55)
	end
	spr_text_hide()
	wait_sync()
end,

function()
	zph += 0.002
	zpx += 0.003
	zpy += 0.004
	zzoom += 0.002
end,

function()
	local s, f = 0.8 + ssin(zzoom, 0.4), frame % 2
	local zdx, zdy, zsx, zsy = scos(zph, s), ssin(zph, s), ssin(zpx, 20), ssin(zpy, 20)

	for y = 0, 63 do
		local ztx, zty = zsx + (y + f) * (zdy + zdx), zsy + y * (zdx - zdy)

		for x = y + f, 63, 2 do
			local xm, ym = 127 - x, 127 - y
			pset(x, y, sget(ztx % 64, zty % 64))
			pset(xm, y)
			pset(x, ym)
			pset(xm, ym)
			pset(y, x)
			pset(ym, x)
			pset(y, xm)
			pset(ym, xm)
			ztx += zdx * 2
			zty -= zdy * 2
		end
	end
end,

-1
end