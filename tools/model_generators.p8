pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function encode_all_models()
	local addr = 0
	local vertices, tris = m_qistibi()
	print("a: " .. addr .. ", v: " .. #vertices .. ", t: " .. #tris) 
	addr = encode_vertices(vertices, addr)
	vertices, tris = m_ochpochmak()
	print("a: " .. addr .. ", v: " .. #vertices .. ", t: " .. #tris) 
	addr = encode_vertices(vertices, addr)
	vertices, tris = m_peremech()
	print("a: " .. addr .. ", v: " .. #vertices .. ", t: " .. #tris) 
	addr = encode_vertices(vertices, addr)
	vertices, tris = m_donut()
	print("a: " .. addr .. ", v: " .. #vertices .. ", t: " .. #tris) 
	addr = encode_vertices(vertices, addr)
	vertices, tris = m_chakchak()
	print("a: " .. addr .. ", v: " .. #vertices .. ", t: " .. #tris) 
	addr = encode_vertices(vertices, addr)
	print(addr)
end

function encode_vertices(vertices, addr)
	for vertex in all(vertices) do
		for coord in all(vertex) do
			poke(addr, coord * 64)
			addr += 1
		end
	end

	return addr
end

function sspeek(addr, scale)
	local v = peek(addr)
	if (v >= 128) v = bor(v, 0xff00)
	return v / scale
end

function decode_shaded_model(addr, nvertices, ntris)
	local vertices, tris = {}, {}
	for c = 1, nvertices do
		local vertex = {}
		for d = 1, 3 do
			vertex[d] = sspeek(addr, 64)
			addr += 1
		end
		add(vertices, vertex)
	end
	for c = 1, ntris do
		local tri = {}
		for d = 1, 5 do
			tri[d] = peek(addr) / ((d == 5) and 64 or 1)
			addr += 1
		end
		add(tris, tri)
	end
	return vertices, tris
end

function decode_tex_model(addr, nvertices, ntris)

end


function m_qistibi()
	local vertices, tris = {}, {}
	local s = 24
	local th = 0.04

	add(vertices, {0, th, 0.4})
	add(vertices, {0, -th, 0.4})
	for c = 0, s do
		local x = cos(c / s / 2)
		local z = sin(c / s / 2) * 0.8 + 0.4
		add(vertices, {x, th - sin(c / s / 2) * th * 2, z})
		add(vertices, {x, -th + sin(c / s / 2) * th * 2, z})
		if c ~= 0 then
			local pc, cc = ((c - 1) * 2), c * 2
			add(tris, {1, pc + 3, cc + 3, 5, 2})
			add(tris, {2, cc + 4, pc + 4, 5, 2})
			add(tris, {cc + 3, pc + 3, pc + 4, 7, 2})
			add(tris, {cc + 3, pc + 4, cc + 4, 7, 2})
		end
	end
	add(tris, {3, s * 2 + 3, 4, 5, 2})
	add(tris, {4, s * 2 + 3, s * 2 + 4, 5, 2})

	return vertices, tris
end

function m_ochpochmak()
    local vertices = {}
    local tris = {}
    local s = 6
    local r = {0, 0.2, 0.4, 0.65, 0.85, 1, 1.1, 1.05, 0}
    local y = {0.6, 0.6, 0.5, 0.4, 0.32, 0.21, 0.1, 0, 0}

    for c = 1, #r do
		for d = 0, s - 1 do
			local even = (d % 2 == 0)
			local angle = (even) and (d / s) or ((d + 1) / s - 0.015)
            local pp = {cos(angle) * r[c], y[c] - 0.25, sin(angle) * r[c]}
            if ((r[c] == 0 and d == 0) or r[c] ~=0) add(vertices, pp)

			if c ~= #r then
				local even_or_last = (even or c == #r - 1)
                local cc, pc, nd = c - 1, c - 2, (d + 1) % s
				local col = even_or_last and 5 or ((c % 2 == 0) and 3 or 4)
				local diff = even_or_last and 2 or 0.2
				if (c == 1) col = 3 diff = 0

				if c == 1 then
					add(tris, {1, d + 2, nd + 2, col, diff})
				elseif c == (#r - 1) then
					add(tris, {pc * s + d + 2, cc * s + 2, pc * s + nd + 2, col, diff})
				else
					add(tris, {pc * s + d + 2, cc * s + d + 2, pc * s + nd + 2, col, diff})
					add(tris, {pc * s + nd + 2, cc * s + d + 2, cc * s + nd + 2, col, diff})
				end
            end
        end
	end

	return vertices, tris
end

function m_peremech()
    local vertices = {}
    local tris = {}
	local s = 16
	local ydiff = {0, 0.08, 0.1, 0.08}
	local angles = {0, 0.1, 0.5, 0.9}
    local r = {0, 0.3, 0.31, 0.35, 0.5, 0.7, 0.9, 1, 1.05, 1, 0.95, 0}
    local y = {0.7, 0.7, 0.8, 0.82, 0.8, 0.7, 0.6, 0.5, 0.25, 0.1, 0.07, 0}

    for c = 1, #r do
		for d = 0, s - 1 do
			local even = (d % 2 == 0)
			local angle = flr(d / #angles) * (1 / s * #angles) + angles[(d % #angles) + 1] * (1 / s * #angles)
            local pp = {cos(angle) * r[c], (y[c] + ydiff[(d % #angles) + 1] * ((c < 4) and 0 or (#r - c) / #r)) - 0.25, sin(angle) * r[c]}
			if ((r[c] == 0 and d == 0) or r[c] ~=0) add(vertices, pp)
			
			if c ~= #r then
				local even_or_last = (even or c == #r - 1)
                local cc, pc, nd = c - 1, c - 2, (d + 1) % s
				local col = (c == 1) and 1 or 5
				local diff = 2
				if (c == 1) col = 3 diff = 0

				if c == 1 then
					add(tris, {1, d + 2, nd + 2, col, diff})
				elseif c == (#r - 1) then
					add(tris, {pc * s + d + 2, cc * s + 2, pc * s + nd + 2, col, diff})
				else
					add(tris, {pc * s + d + 2, cc * s + d + 2, pc * s + nd + 2, col, diff})
					add(tris, {pc * s + nd + 2, cc * s + d + 2, cc * s + nd + 2, col, diff})
				end
            end
        end
	end

	return vertices, tris
end

function m_donut()
	local vertices, tris = {}, {}
	local s = 15
	local r = 0.4

	for c = 0, s - 1 do
		local p = {cos(c / s), sin(c / s)}
		for d = 0, s - 1 do
			local pp = {p[1] * (1 + cos(d / s) * r), p[2] * (1 + cos(d / s) * r), sin(d / s) * r}
			add(vertices, pp)
			local nc, nd = (c + 1) % s, (d + 1) % s
			local col = (d >= s / 2) and 5 or 4
			local diff = (d >= s / 2) and 0.5 or 2
			add(tris, {c * s + d + 1, nc * s + d + 1, c * s + nd + 1, col, diff})
			add(tris, {c * s + nd + 1, nc * s + d + 1, nc * s + nd + 1, col, diff})
		end
	end

	return vertices, tris
end

function m_chakchak()
    local vertices = {}
    local tris = {}
    local s = 14
    local r = {0, 0.18, 0.22, 0.29, 0.48, 0.47, 0.42, 0}
    local y = {1, 0.95, 0.9, 0.8, 0.25, 0.12, 0.05, 0}

    for c = 1, #r do
        for d = 0, s - 1 do
            local pp = {cos(d / s) * r[c], y[c] - 0.5, sin(d / s) * r[c]}
            if ((r[c] == 0 and d == 0) or r[c] ~=0) add(vertices, pp)

			if c ~= #r then
				local cc, pc, nd = c - 1, c - 2, (d + 1) % s
				local tx1, tx2 = d / s * 63, (d + 1) / s * 63
				local ty1, ty2 = y[c] * 63, y[c + 1] * 63
				if c == 1 then
					add(tris, {1, d + 2, nd + 2, 32, ty1, tx1, ty2, tx2, ty2})
				elseif c == (#r - 1) then
					add(tris, {pc * s + d + 2, cc * s + 2, pc * s + nd + 2, tx1, ty1, 32, ty2, tx2, ty1})
				else
					add(tris, {pc * s + d + 2, cc * s + d + 2, pc * s + nd + 2, tx1, ty1, tx1, ty2, tx2, ty1})
					add(tris, {pc * s + nd + 2, cc * s + d + 2, cc * s + nd + 2, tx2, ty1, tx1, ty2, tx2, ty2})
				end
			end
        end
	end

	return vertices, tris
end

-->8
-- px9 compress

-- x0,y0 where to read from
-- w,h   image width,height
-- dest  address to store
-- vget  read function (x,y)

function px9_comp(x0,y0,w,h,dest,vget)

local dest0=dest
local bit=1 
local byte=0

local function vlist_val(l, val)
	-- find positon
	for i=1,#l do
		if(l[i] == val) then
		
			-- jump to top
			for j=i,2,-1 do
				l[j]=l[j-1]
			end
			l[1] = val
			return i
		end
	end
end


function putbit(bval)
	if (bval) byte+=bit 
	poke(dest, byte) bit*=2
	if (bit==256) then
		bit=1 byte=0
		dest += 1			
	end
end

function putval(val, bits)
	if (bits == 0) return
	for i=0,bits-1 do
		putbit(band(val,shl(1,i))>0)
	end
end

function putnum(val)
	local bits = 1
	while true do
		local mx=shl(1,bits)-1
		local vv=min(val,mx)
		putval(vv,bits)
		val -= vv
		bits += 1
		if (vv<mx) return
	end
end



-- first_used

local el={}
local found={}
local highest=0
for y=y0,y0+h-1 do
	for x=x0,x0+w-1 do
		c=vget(x,y)
		if not found[c] then
			found[c]=true
			add(el,c)
			highest=max(highest,c)
		end
	end
end

-- header

local bits=1
while (highest>(2^bits)-1) do
	bits+=1
end

putnum(w-1)
putnum(h-1)
putnum(bits-1)
putnum(#el-1)
for i=1,#el do
	putval(el[i],bits)
end


-- data

local pr={} -- predictions

local dat={}

for y=y0,y0+h-1 do
	for x=x0,x0+w-1 do
		local v=vget(x,y)  
		
		local a=0
		if (y>y0) a+=vget(x,y-1)
		
		-- create vlist if needed
		local l=pr[a]
		if not l then
			l={}
			for i=1,#el do
				l[i]=el[i]
			end
			pr[a]=l
		end
		
		-- add to vlist
		add(dat,vlist_val(l,v))
		
		-- and to running list
		vlist_val(el, v)
		
	end
end

-- write
-- store bit-0 as runtime len
-- start of each run

local mode=1 -- predicted
local pos=1

while (pos <= #dat) do

	-- count length
	local pos0=pos
	
	if (mode == 0) then
		-- not predicted
		while (dat[pos]!=1 and 
			pos <= #dat) do pos+=1 end
	else
		-- predicted
		while (dat[pos]==1 and 
			pos <= #dat) do pos+=1 end
	end

	local splen = pos-pos0
	putnum(splen-1)

	if (mode==0) do
		-- not predicted:
		-- values will all be >= 2
		while (pos0 < pos) do
			putnum(dat[pos0]-2)
			pos0+=1
		end
	end

	mode=1-mode -- flip
end

local len=dest-dest0
if (bit==1) len-=1--unused byte

return len

end


__gfx__
