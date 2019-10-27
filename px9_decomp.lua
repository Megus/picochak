function px9_decomp(x0,y0,src)
	local function vlist_val(l, val)
		for i=1,#l do
			if l[i]==val then
				for j=i,2,-1 do
					l[j]=l[j-1]
				end
				l[1] = val
				return i
			end
		end
	end

	local cache,cache_bits=0,0
	function getval(bits)
		if cache_bits<16 then
			cache+=lshr(peek2(src),16-cache_bits)
			cache_bits+=16
			src+=2
		end
		local val=lshr(shl(cache,32-bits),16-bits)
		cache=lshr(cache,bits)
		cache_bits-=bits
		return val
	end

	function gn1()
		local bits,tot=1,1

		while 1 do
			local mx,vv=2^bits-1,getval(bits)
			tot+=vv
			bits+=1
			if (vv<mx) return tot
		end
	end

	local w,h,b,el,pr,x,y,splen,mode = gn1(),gn1(),gn1(),{},{},0,0,0

	for i=1,gn1() do
		add(el,getval(b))
	end
	for y=y0,y0+h-1 do
		for x=x0,x0+w-1 do

			splen-=1

			if splen<1 then
				splen,mode=gn1(),not mode
			end

			local a= y>y0 and sget(x,y-1) or 0

			local l=pr[a]
			if not l then
				l={}
				for e in all(el) do
					add(l,e)
				end
				pr[a]=l
			end

			local idx=mode and 1 or gn1()+1
			local v=l[idx]

			vlist_val(l, v)
			vlist_val(el, v)

			sset(x,y,v)

			x+=1
			y+=flr(x/w)
			x%=w
		end
	end
end
