sr_stars, sr_mode, sr_dx, sr_dy, sr_new = {}, 0, 0, 0, {
	function(old_star)
		return old_star == nil and {rnd(128), rnd(128), rnd(5) - 2} or old_star
	end,

	function()
		return {0, 0, rnd(3), rnd(2) - 1, rnd(2) - 1, rndp(50, 50), rndp(3, 1)}
	end,

	function(old_star)
		return old_star == nil and {rnd(128), rnd(128), rnd(3), rndp(3, 1)} or {old_star[1], old_star[2], old_star[3], rndp(3, 1)}
	end,
}

function stars_set_mode(new_mode, new_dx, new_dy)
	sr_dx, sr_dy = new_dx or 1, new_dy or 0

	if sr_mode ~= new_mode then
		sr_mode = new_mode
		for i = 1, 50 do sr_stars[i] = sr_new[sr_mode](sr_stars[i]) end
	end
end

function stars_update()
	for i = 1, 50 do
		if (out_of_screen(sr_stars[i])) sr_stars[i] = sr_new[sr_mode]()

		local s = sr_stars[i]
		local s4, s6 = s[4], s[6]

		if sr_mode == 1 then
			s[3] += 0.03
			if (s[3] > 2.5) s[1] = 130
		elseif sr_mode == 2 then
			s[1] = 64 + s4 / s6 * 2500
			s[2] = 64 + s[5] / s6 * 2500
			s[6] -= s[7] * sr_dx
		else
			s[1] += s4 * sr_dx
			s[2] += s4 * sr_dy
		end
	end
end

function stars_draw()
	for s in all(sr_stars) do
		pset(s[1], s[2], 0x100f - abs(flr(s[3])))
	end
end
