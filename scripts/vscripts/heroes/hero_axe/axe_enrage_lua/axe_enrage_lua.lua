axe_enrage_lua = class({})
LinkLuaModifier( "modifier_axe_enrage_lua", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_lua", LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------------------------------------

function axe_enrage_lua:OnSpellStart()	
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_axe_enrage_lua",
		{ duration = self:GetSpecialValueFor("duration") }
	)

	self:PlayEffects()
end

function axe_enrage_lua:PlayEffects()
	local sound_cast = "Hero_Ursa.Enrage"

	EmitSoundOn( sound_cast, self:GetCaster() )
endage_lua:OnSpellStart()

	local bonus_duration = self:GetSpecialValueFor("duration")
	
	self:GetCaster():Purge(false, true, false, true, false)

	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_axe_enrage_lua",
		{ duration = bonus_duration }
	)
	if HasTalent(self:GetCaster(),"special_bonus_axe_4") then
			self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_axe_enrage_cleave_lua",
			{ duration = bonus_duration }
	)
		end
	self:PlayEffects()
end

function axe_enrage_lua:PlayEffects()
	local sound_cast = "Hero_Ursa.Enrage"

	EmitSoundOn( sound_cast, self:GetCaster() )
end