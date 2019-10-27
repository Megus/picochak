local palette = {
    {0x00, 0x00, 0x00}, {0x1d, 0x2b, 0x53}, {0x7e, 0x25, 0x53}, {0x00, 0x87, 0x51},
    {0xab, 0x52, 0x36}, {0x5f, 0x57, 0x4f}, {0xc2, 0xc3, 0xc7}, {0xff, 0xf1, 0xe8},
    {0xff, 0x00, 0x4d}, {0xff, 0xa3, 0x00}, {0xff, 0xec, 0x27}, {0x00, 0xe4, 0x36},
    {0x29, 0xad, 0xff}, {0x83, 0x76, 0x9c}, {0xff, 0x77, 0xa8}, {0xff, 0xcc, 0xaa},
}

--[[
#000000 #1D2B53 #7E2553 #008751
#AB5236 #5F574F #C2C3C7 #FFF1E8
#FF004D #FFA300 #FFEC27 #00E436
#29ADFF #83769C #FF77A8 #FFCCAA
]]

function loadfile(filename)
    local file = io.open(filename, "rb")
    local data = file:read("*all")
    file:close()
    return data
end

function rgb_to_pico16(r, g, b)
    local col = 0
    local mindiff = 10000
    for i = 1, 16 do
        local diff = math.abs(r - palette[i][1]) + math.abs(g - palette[i][2]) + math.abs(b - palette[i][3])
        if diff < mindiff then
            col = i - 1
            mindiff = diff
        end
    end

    return hex_digit(col)
end

function hex_digit(digit)
    if digit < 10 then
        return "" .. digit
    else
        digit = math.min(digit, 15)
        return string.char(87 + digit)
    end
end

function byte_at(data, idx)
    return string.byte(data:sub(idx, idx))
end

function filler_for_width(width)
    local filler = ""
    if width < 128 then
        for c = 0, 127 - width do
            filler = filler .. "0"
        end
    end
    return filler
end

function convert_grayscale(filename, width, height)
    local data = loadfile(filename)

    local picospr = ""
    local filler = filler_for_width(width)

    local idx = 9
    for y = 1, height do
        for x = 1, width do
            local gray = math.floor(byte_at(data, idx) / 255 * 16)
            picospr = picospr .. hex_digit(gray)
            idx = idx + 4
        end
        picospr = picospr .. filler .. "\n"
    end
    print(picospr)
end

function convert_pico16(filename, width, height)
    local data = loadfile(filename)

    local picospr = ""
    local filler = filler_for_width(width)

    local idx = 9
    for y = 1, height do
        for x = 1, width do
            local r = byte_at(data, idx)
            local g = byte_at(data, idx + 1)
            local b = byte_at(data, idx + 2)
            picospr = picospr .. rgb_to_pico16(r, g, b)
            idx = idx + 4
        end
        picospr = picospr .. filler .. "\n"
    end
    print(picospr)
end


--convert_grayscale("texture1-c.tiff", 64, 64)
--convert_pico16("logo_16_101x64.tiff", 101, 64)
--convert_pico16("logo_16_128x128.tiff", 128, 128)
--convert_pico16("planet_straight.tiff", 96, 48)
--convert_pico16("font.tiff", 64, 40)
--convert_pico16("chak_spr.tiff", 16, 16)
--convert_pico16("bugulma.tiff", 72, 64)
--convert_pico16("tatarornament.tiff", 64, 64)
--convert_pico16("donut.tiff", 16, 16)
--convert_pico16("chak.tiff", 16, 16)
--convert_pico16("ochpochmak.tiff", 16, 16)
--convert_pico16("ochpochmak-r.tiff", 16, 16)
--convert_pico16("qistibi.tiff", 16, 16)
--convert_pico16("qistibi-r.tiff", 16, 16)
--convert_pico16("peremech.tiff", 16, 16)
--convert_pico16("donut2.tiff", 16, 16)
convert_pico16("chakchak.tiff", 16, 16)
