terrorblade_conjure_image_lua = class({})
LinkLuaModifier( "modifier_terrorblade_conjure_image_lua", "heroes/hero_terror/terrorblade_conjure_image_lua/modifier_terrorblade_conjure_image_lua", LUA_MODIFIER_MOTION_NONE )

function terrorblade_conjure_image_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_mirror_image.vpcf", context )
end

function terrorblade_conjure_image_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "illusion_duration" )
	local outgoing = self:GetSpecialValueFor( "illusion_outgoing_tooltip" )
	local incoming = self:GetSpecialValueFor( "illusion_incoming_damage_total_tooltip" )
	local distance = 72

	count = 1
	
	if self:GetCaster():FindAbilityByName("special_bonus_terrorblade_agi9")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_terrorblade_agi9"):GetLevel() > 0 then 
			count = 2
		end
	end
	
	for i = 1, count do
		local illusions = CreateIllusions(caster, caster,
			{
				outgoing_damage = 0, --outgoing - 100,
				incoming_damage = incoming - 100,
				duration = duration,
			}, -- hModiiferKeys
			1, -- nNumIllusions
			distance, -- nPadding
			false, -- bScramblePosition
			true -- bFindClearSpace
		)
		local illusion = illusions[1]

		self:SetContextThink( DoUniqueString( "terrorblade_conjure_image_lua" ),function()
			illusion:AddNewModifier(caster, self, "modifier_terrorblade_conjure_image_lua", { duration = duration })
			illusion:SetBaseDamageMin(self:GetCaster():GetBaseDamageMin()*outgoing/100-self:GetCaster():GetBaseAgility())
			illusion:SetBaseDamageMax(self:GetCaster():GetBaseDamageMax()*outgoing/100-self:GetCaster():GetBaseAgility())

			EmitSoundOn("Hero_Terrorblade.ConjureImage", illusion )
		end, FrameTime()*2)
	end
end