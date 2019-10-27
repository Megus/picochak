function init_blows()
local blows = {}

function draw_blow(x, y, r)
	for col = 0x1008, 0x1005, -1 do
		circfill(x, y, r, col)
		r *= 0.75
	end
end

function blows_add(x, y)
	add(blows, {x, y, rnd(3)})
end

function blows_update()
	for blow in all(blows) do
		blow[3] += 0.3
		if (blow[3] > 16) del(blows, blow)
	end
end

function blows_draw()
	for blow in all(blows) do draw_blow(blow[1], blow[2], blow[3]) end
end
end