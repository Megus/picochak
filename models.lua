function model_tris(r, s)
	local tris, lastidx = {}, (r - 2) * s + 2

    for c = 2, lastidx, s do
		for d = 0, s - 1 do
			local pc, nd = c - s, (d + 1) % s

			if c == 2 then
				add(tris, {1, d + 2, nd + 2, 3, 0})
			elseif c == lastidx then
				add(tris, {pc + d, c, pc + nd, 5, 2})
			else
				add(tris, {pc + d, c + d, pc + nd, 5, 2})
				add(tris, {pc + nd, c + d, c + nd, 5, 2})
			end
		end
	end
	return tris
end

function load_models()
	local addr = 9289
	for n in all({52, 44, 162, 225, 86}) do
		local vertices = {}
		for c = 1, n do
			local vertex = {}
			for d = 1, 3 do
				local v = peek(addr)
				if (v > 127) v = bor(v, 0xff00)
				add(vertex, v / 64)
				addr += 1
			end
			add(vertices, vertex)
		end
		add(m_vertices, vertices)
	end

	local tris = {{3, 51, 4, 5, 2}, {4, 51, 52, 5, 2}}
	for c = 3, 49, 2 do
		local c1, c2 = c + 1, c + 2
		add(tris, {1, c, c2, 5, 2})
		add(tris, {2, c + 3, c1, 5, 2})
		add(tris, {c2, c, c1, 7, 2})
		add(tris, {c2, c1, c + 3, 7, 2})
	end
	add(m_tris, tris)

	tris = model_tris(9, 6)
	for c = 9, 80, 4 do
		tris[c][4], tris[c][5], tris[c + 1][4], tris[c + 1][5] = 4, 0, 3, 0
	end
	add(m_tris, tris)

	add(m_tris, model_tris(12, 16))

	tris = {}
	for c = 1, 211, 15 do
		for d = 0, 14 do
			local nc, nd, col, diff = (c + 15) % 225, (d + 1) % 15, 4, 2
			if (d > 6) col, diff = 5, 0.5
			add(tris, {c + d, nc + d, c + nd, col, diff})
			add(tris, {c + nd, nc + d, nc + nd, col, diff})
		end
	end
	add(m_tris, tris)

	tris = model_tris(8, 14)
	local y, idx = {63, 60, 56, 50, 16, 8, 3, 0}, 1

	for c = 1, 7 do
		for d = 0, 13 do
			local tx1, ty1 = d * 4.5, y[c]
			local tx2, ty2 = tx1 + 4.5, y[c + 1]
			local tx3, ty3 = tx2, ty2

			local function upd_tri()
				local tri = tris[idx]
				tris[idx] = {tri[1], tri[2], tri[3], tx1, ty1, tx2, ty2, tx3, ty3}
				idx += 1
			end

			if c == 1 then
				tx1, tx2 = 32, tx1
			elseif c == 7 then
				tx2, ty3 = 32, ty1
			else
				ty3, tx2 = ty1, tx1
				upd_tri()
				ty3, tx1, tx2 = ty2, tx3, tx1
			end
			upd_tri()
		end
	end
	add(m_tris, tris)
end
