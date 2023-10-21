axe_enrage_lua = class({})
LinkLuaModifier( "modifier_axe_enrage_lua", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_enrage_cleave_lua", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_cleave_lua", LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------------------------------------
function HasTalent(unit, talentName)
    if unit:HasAbility(talentName) then
        if unit:FindAbilityByName(talentName):GetLevel() > 0 then return true end
    end
    return false
end

function axe_enrage_lua:OnSpellStart()

	local bonus_duration = self:GetSpecialValueFor("duration")
	
	self:GetCaster():Purge(false, true, false, true, false)

	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_axe_enrage_lua",
		{ duration = bonus_duration }
	)
	if HasTalent(self:GetCaster(),"npc_dota_hero_axe_4") then
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