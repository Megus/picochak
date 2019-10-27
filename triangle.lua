function tex_triangle(x1, y1, x2, y2, x3, y3, light, tx1, ty1, tx2, ty2, tx3, ty3)
	if (y1 > y2) y1, y2, x1, x2, ty1, ty2, tx1, tx2 = y2, y1, x2, x1, ty2, ty1, tx2, tx1
	if (y1 > y3) y1, y3, x1, x3, ty1, ty3, tx1, tx3 = y3, y1, x3, x1, ty3, ty1, tx3, tx1
	if (y2 > y3) y2, y3, x2, x3, ty2, ty3, tx2, tx3 = y3, y2, x3, x2, ty3, ty2, tx3, tx2

	local dy13, ttx1, ttx2, tty1, tty2, lx1, lx2 = y3 - y1, tx1, tx1, ty1, ty1, x1, x1
	local dx1, dtx1, dty1, dx2, dtx2, dty2, dy23 = (x3 - x1) / dy13, (tx3 - tx1) / dy13, (ty3 - ty1) / dy13

	local function tex_line(x1, x2, y, tx1, ty1, tx2, ty2)
		local dtx, dty = (tx2 - tx1) / (x2 - x1), (ty2 - ty1) / (x2 - x1)
		for x = x1, x2 do
			pset(x, y, colormap[flr(sget(tx1, ty1) * light)])
			tx1 += dtx
			ty1 += dty
		end
	end

	local function fill(y1, y2)
		for y = y1, min(y2, 127) do
			if lx1 > lx2 then
				tex_line(lx2, lx1, y, ttx2, tty2, ttx1, tty1)
			else
				tex_line(lx1, lx2, y, ttx1, tty1, ttx2, tty2)
			end

			lx1 += dx1
			lx2 += dx2
			ttx1 += dtx1
			tty1 += dty1
			ttx2 += dtx2
			tty2 += dty2
		end
	end

	if y2 > y1 then
		local dy12 = y2 - y1
		dx2, dtx2, dty2 = (x2 - x1) / dy12, (tx2 - tx1) / dy12, (ty2 - ty1) / dy12
		fill(y1, y2)
	end
	dy23, lx1, lx2, ttx1, tty1, ttx2, tty2 = y3 - y2, x1 + (y2 - y1) * dx1, x2, tx1 + (y2 - y1) * dtx1, ty1 + (y2 - y1) * dty1, tx2, ty2
	dx2, dtx2, dty2 = (x3 - x2) / dy23, (tx3 - tx2) / dy23, (ty3 - ty2) / dy23
	fill(y2, y3)
end


function triangle(x1, y1, x2, y2, x3, y3, col)
	if (min(x1, min(x2, x3)) > 127 or max(x1, max(x2, x3)) < 0 or min(y1, min(y2, y3)) > 127 or max(y1, max(y2, y3)) < 0) return

	if (y1 > y2) y1, y2, x1, x2 = y2, y1, x2, x1
	if (y1 > y3) y1, y3, x1, x3 = y3, y1, x3, x1
	if (y2 > y3) y2, y3, x2, x3 = y3, y2, x3, x2

	local dx1, tx1, tx2, dx2 = (x3 - x1) / (y3 - y1), x1, x1

	local function fill(y1, y2)
		for y = y1, min(y2, 127) do
			rectfill(tx1, y, tx2, y, col)
			tx1 += dx1
			tx2 += dx2
		end
	end

	if y2 > y1 then
		dx2 = (x2 - x1) / (y2 - y1)
		fill(y1, y2)
	end
	tx1, tx2, dx2 = x1 + (y2 - y1) * dx1, x2, (x3 - x2) / (y3 - y2)
	fill(y2, y3)
end
