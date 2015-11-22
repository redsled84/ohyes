local txt = {}

function txt.parseMap(path, option)
	local fs = love.filesystem
	if path ~= nil then
		local layers = {}
		local temp = {}
		local w, h, tileW, tileH
		local counter = 0

		local state = false
		local layer = ""
		for line in fs.lines(path) do
			if line:sub(1,6) == "width=" then
				w = tonumber(line:sub(7))
			elseif line:sub(1,7) == "height=" then
				h = tonumber(line:sub(8))
			elseif line:sub(1,10) == "tilewidth=" then
				tileW = tonumber(line:sub(11))
			elseif line:sub(1,11) == "tileheight=" then
				tileH = tonumber(line:sub(12))
			end
			if line:sub(1,5) == "type=" then
				layer = line:sub(6)
			end

			if (line:sub(1,5) == "data=") or
				(tonumber(line:sub(1,1)) or tonumber(line:sub(2,2))) then
				state = true
			elseif string.len(line) == 0 then
				state = false
				counter = counter + 1
			end
			if tonumber(line:sub(1,1)) or tonumber(line:sub(2,2)) and state then
				for s in line:gmatch("([^,]*),") do
					table.insert(temp, tonumber(s))
				end
			end
			if counter > 0 and #temp > 0 and not state then
				table.insert(layers, {name = layer, data = temp})
				temp = {}
				counter = 0
			end
		end
		
		return {
					w = w,
					h = h,
					tilewidth = tileW,
					tileheight = tileH,
					layers = layers
				}
	else
		error("No .txt path passed")
	end
end

return txt
