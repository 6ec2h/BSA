mars_lil = class({})
LinkLuaModifier( "modifier_mars_lil", "heroes/hero_mars/mars_lil/modifier_mars_lil", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_lil_debuff", "heroes/hero_mars/mars_lil/modifier_mars_lil_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_boost", "heroes/hero_mars/modifier_mars_boost", LUA_MODIFIER_MOTION_NONE )

function mars_lil:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetDuration()

	-- addd buff
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_mars_lil", -- modifier name
		{ duration = duration } -- kv
	)
	
		if self:GetCaster():FindAbilityByName("special_bonus_mars_str7")~=nil then
			if self:GetCaster():FindAbilityByName("special_bonus_mars_str7"):GetLevel() > 0 then 
			caster:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_mars_boost", -- modifier name
				{ duration = 3 } -- kv
			)
		end
	end
end