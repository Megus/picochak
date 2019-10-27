function tmatrix(angles, scale, offsets)
	local c1, c2, c3, s1, s2, s3 = cos(angles[1]), cos(angles[2]), cos(angles[3]), sin(angles[1]), sin(angles[2]), sin(angles[3])
	return mmult({2,0,0,0,0,2,0,0,0,0,-1,1,0,0,0.02,0},
		mmult({scale,0,0,offsets[1],0,scale,0,offsets[2],0,0,scale,offsets[3],0,0,0,1},
			{c2,s2*s3,c3*s2,0,s1*s2,c1*c3-c2*s1*s3,-c1*s3-c2*c3*s1,0,-c1*s2,c3*s1+c1*c2*s3,c1*c2*c3-s1*s3,0,0,0,0,1}))
end

function is_cw(p1, p2, p3)
	return (p2[1]-p1[1])*(p3[2]-p1[2])-(p2[2]-p1[2])*(p3[1]-p1[1])>0
end

function normal(p1, p2, p3)
	local ux, uy, uz, vx, vy, vz = p2[1]-p1[1], p2[2]-p1[2], p2[3]-p1[3], p3[1]-p1[1], p3[2]-p1[2], p3[3]-p1[3]
	local x, y, z = (uy * vz - uz * vy) / 256, (uz * vx - ux * vz) / 256, (ux * vy - uy * vx) / 256
	local len = sqrt(x*x+y*y+z*z)
	return {x/len,y/len,z/len}
end

function vmmult(v, m)
	local v1, v2, v3 = v[1], v[2], v[3]
	return {m[1]*v1+m[2]*v2+m[3]*v3+m[4],m[5]*v1+m[6]*v2+m[7]*v3+m[8],m[9]*v1+m[10]*v2+m[11]*v3+m[12],m[13]*v1+m[14]*v2+m[15]*v3+m[16]}
end

function mmult(m1, m2)
	local r = {}
	for c = 0, 3 do
		for d = 0, 3 do
			local t = 0
			for e = 0, 3 do
				t += m1[c*4+e+1]*m2[e*4+d+1]
			end
			add(r, t)
		end
	end
	return r
end

function radix_sort(arr, mask, idx1, idx2)
	local c, rb = idx1, idx2 + 1
	while c < rb do
		if band(arr[c][1], mask) ~= 0 then
			repeat
				rb -= 1
				if (rb == c) break
			until band(arr[rb][1], mask) == 0
			arr[c], arr[rb] = arr[rb], arr[c]
		end
		c += 1
	end
	if mask ~= 1 then
		mask /= 2
		if (rb - 1 > idx1) radix_sort(arr, mask, idx1, rb - 1)
		if (rb < idx2) radix_sort(arr, mask, rb, idx2)
	end
end

function get_v2d(vertices, matrix)
	local v2d = {}
	for v in all(vertices) do
		local pv = vmmult(v, matrix)
		add(v2d, {64 + pv[1] / pv[4], 64 - pv[2] / pv[4], pv[3]})
	end
	return v2d
end

function m3d_tex(vertices, tris, angles, scale, offsets)
	local v2d = get_v2d(vertices, tmatrix(angles, scale, offsets))

	for tri in all(tris) do
		local p1, p2, p3 = v2d[tri[1]], v2d[tri[2]], v2d[tri[3]]
		if is_cw(p1, p2, p3) then
			tex_triangle(p1[1], p1[2], p2[1], p2[2], p3[1], p3[2], -ssin(abs(normal(p1, p2, p3)[3]), 8, 4), tri[4], tri[5], tri[6], tri[7], tri[8], tri[9])
		end
	end
end

function m3d_shaded(vertices, tris, angles, scale, offsets)
	local sorted, v2d = {}, get_v2d(vertices, tmatrix(angles, scale, offsets))

	for tri in all(tris) do
		local p1, p2, p3 = v2d[tri[1]], v2d[tri[2]], v2d[tri[3]]
		if is_cw(p1, p2, p3) then
			local pv3 = normal(p1, p2, p3)[3]
			local light = min(1, abs(tri[5] < 2 and (pv3 * tri[5]) or (pv3 * pv3)))
			add(sorted, {p1[3] + p2[3] + p3[3], p1, p2, p3, tri[4] + (light < 0.2 and (0x10 + dither[9 - flr(light * 40)]) or (0x80 + dither[ceil(light * 20 - 3)]))})
		end
	end

	radix_sort(sorted, 0x400, 1, #sorted)

	for tri in all(sorted) do
		local p1, p2, p3 = tri[2], tri[3], tri[4]
		triangle(p1[1], p1[2], p2[1], p2[2], p3[1], p3[2], tri[5])
	end
end
