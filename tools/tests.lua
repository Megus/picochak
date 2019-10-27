function tests()
	local a = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}

	return {
		coupdate = function()
			wait_sync()
		end,

		update = function()
			for c = 1, 5000 do
				-- Test iterator vs array access
				-- Result: iterator is slower (43% / 23%)
				--local i = all(a)
				--local r = i() + i() +i() + i() +i() + i() +i() + i() +i() + i() +i() + i() +i() + i() +i() + i()
				--local r = a[1] + a[2] + a[3] + a[4] + a[5] + a[6] + a[7] + a[8] + a[9] + a[10] + a[11] + a[12] + a[13] + a[14] + a[15] + a[16]

				-- Test peek4 vs array access
				-- Resultt: array access is faster (14.69% / 15.4%)
				--local r = peek4(0x4300 + c)
				--local r = a[2 + 6]

				-- Test band(x, 0xffff) vs flr(x)
				-- Result: flr is a bit faster (15.47% / 15.63%)
				--local r = flr(2.1)
				--local r = band(2.1, 0xffff)

				-- Test: band vs x % y
				-- % is faster (14.69% / 15.63%)
				--local r = band(123, 0x3f)
				local r = 123 % 62

				for c = 1, #tbl do
					print(tbl[c])
				end -- 12 tokens


				for v in all(tbl) do
					print(v)
				end -- 10 tokens
			end
		end,

		draw = function()

		end,
	}

end