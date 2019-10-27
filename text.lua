function spr_from_letter(letter)
	for c = 1, 40 do
		if letter == sub(texts, c, c) then
			c -= 1
			return 8 + c % 8 + flr(c / 8) * 16
		end
	end
end

function spr_letter(x, y, sprn, col)
	pal(7, 0)
	for c = -1, 1 do
		for d = -1, 1 do
			spr(sprn, x + c, y + d)
		end
	end
	pal(7, col)
	spr(sprn, x, y)
	pal(7, 7)
end

function pico_print(x, y, str)
	camera(0, -16)
	for c = -1, 1 do
		for d = -1, 1 do
			print(str, x + c, y + d, 0)
		end
	end
	print(str, x, y, 15)
	camera()
end

function spr_print(x, y, str, col)
	for c = 1, #str do
		spr_letter(x + c * 8 - 8, y, spr_from_letter(sub(str, c, c)), col or 7)
	end
end

function tnum(off)
	return tonum(sub(texts, t_idx + off, t_idx + off + 2))
end

function pico_text_show(sync)
	pt_idx1 = t_idx + 7
	pt_sx, pt_sy, pt_idx2, pt_show = tnum(1), tnum(4), pt_idx1, true

	if sync ~= false then
		wait_sync()
		pico_text_hide()
	end
end

function pico_text_hide()
	pt_show = false
end

function spr_text_show(col)
	st_sx, st_sy, st_col, st_letters, st_pletters, st_state = tnum(1), tnum(4), col or 14, {}, {}, 1

	for c = t_idx + 7, t_idx + 27 do
		local l = sub(texts, c, c)
		if l == "|" then
			t_idx = c
			break
		end
		add(st_letters, spr_from_letter(l))
		add(st_pletters, 0.08 - 0.01 * (c - t_idx))
	end
	st_len = #st_letters
end

function spr_text_hide()
	for c = 1, st_len do
		st_pletters[c], st_state = 0.01 - 0.01 * c, 2
	end
end
