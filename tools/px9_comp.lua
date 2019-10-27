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
