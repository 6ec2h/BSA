local a
if IsServer() then
    a = ""--GetDedicatedServerKeyV3("1")
    CustomNetTables:SetTableValue("common", "encrypt_key", { _ = a })
else
    a = (CustomNetTables:GetTableValue("common", "encrypt_key") or {})._ or ""
end


_G.decryptModule = function(c)

	function hex_to_str(hex)
		local str = ""
		for i = 1, #hex, 2 do
			local hex_byte = hex:sub(i, i + 1)
			local byte = tonumber(hex_byte, 16)
			str = str .. string.char(byte)
		end
		return str
	end

	function v_d(t, key)
		local d = {}
		local k_i = 1
		for i = 1, #t do
			local char = t:sub(i, i)
			if char:match("%a") then
				local b = char:match("%u") and 65 or 97
				local key_char = key:sub(k_i, k_i):lower()
				local key_shift = string.byte(key_char) - 97
				local new_char = string.char(((string.byte(char) - b - key_shift) % 26) + b)
				table.insert(d, new_char)
				k_i = k_i + 1
				if k_i > #key then 
					k_i = 1
				end
			else
				table.insert(d, char)
			end
		end

		return table.concat(d)
	end

	local c_h = hex_to_str(c)
	local d = v_d(c_h, a)
	return d
end