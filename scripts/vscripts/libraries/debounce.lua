function Debounce(delay, callback)
	local nextTimeKey, lastResultKey = DoUniqueString("DebounceNextTime"), DoUniqueString("DebounceLastResult")

	return function(self, ...)
		local curTime = GameRules:GetGameTime()
		if (self[nextTimeKey] and self[nextTimeKey] > curTime) then
			return self[lastResultKey] and unpack(self[lastResultKey])
		end

		local result = {callback(self, ...)}
		local notEmptyResult = next(result) ~= nil

		self[lastResultKey] = notEmptyResult and result
		self[nextTimeKey] = curTime + delay

		return notEmptyResult and unpack(result)
	end
end