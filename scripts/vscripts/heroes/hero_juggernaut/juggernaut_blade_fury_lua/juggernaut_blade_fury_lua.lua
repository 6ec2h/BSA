juggernaut_blade_fury_lua = class({})
LinkLuaModifier( "modifier_juggernaut_blade_fury_lua", "heroes/hero_juggernaut/juggernaut_blade_fury_lua/modifier_juggernaut_blade_fury_lua", LUA_MODIFIER_MOTION_NONE )

function juggernaut_blade_fury_lua:OnSpellStart()
	self:GetCaster():Purge(false, true, false, false, false)
	local caster = self:GetCaster()

	-- load data
	local bDuration = self:GetSpecialValueFor("duration")
	
		if self:GetCaster():FindAbilityByName("special_bonus_juggernaut_agi2")~=nil then
			if self:GetCaster():FindAbilityByName("special_bonus_juggernaut_agi2"):GetLevel() > 0 then 
				bDuration = 4
			end
		end

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_juggernaut_blade_fury_lua", -- modifier name
		{ duration = bDuration } -- kv
	)
end