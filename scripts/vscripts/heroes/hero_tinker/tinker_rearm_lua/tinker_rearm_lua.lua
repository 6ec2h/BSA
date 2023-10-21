tinker_rearm_lua = class({})

function tinker_rearm_lua:OnSpellStart()
	EmitSoundOn( "Hero_Tinker.Rearm", self:GetCaster() )
end

function tinker_rearm_lua:OnChannelFinish( bInterrupted )
	local caster = self:GetCaster()
	StopSoundOn( "Hero_Tinker.Rearm", self:GetCaster() )

	if bInterrupted then return end
	for i=0,caster:GetAbilityCount()-1 do
		local ability = caster:GetAbilityByIndex( i )
		if ability and ability:GetAbilityType()~=DOTA_ABILITY_TYPE_ATTRIBUTES and ability ~= self and not self:IsItemException(ability) then
			ability:RefreshCharges()
			ability:EndCooldown()
		end
	end
	for i=0,8 do
		local item = caster:GetItemInSlot(i)
		if item then
			local pass = false
			if item:GetPurchaser()==caster and not self:IsItemException( item ) then
				pass = true
			end

			if pass then
				item:EndCooldown()
			end
		end
	end
	self:PlayEffects()
end

function tinker_rearm_lua:IsItemException( item )
	return self.ItemException[item:GetName()]
end

tinker_rearm_lua.ItemException = {
	["item_aeon_disk"] = true,
	["item_agi"] = true,
	["item_str"] = true,
	["item_int"] = true,
	["item_random_stat"] = true,
	["item_str_50"] = true,
	["item_agi_50"] = true,
	["item_int_50"] = true,
	["item_black_king_bar_lua1"] = true,
	["item_black_king_bar_lua2"] = true,
	["item_black_king_bar_lua3"] = true,
	["item_refresher"] = true,
	["item_sphere"] = true,
	["item_aeon_of_tarrasque"] = true,
	["item_aeon_of_tarrasque2"] = true,
	["item_aeon_of_tarrasque3"] = true,
	["hero_rubick_ability"] = true,
	
}

function tinker_rearm_lua:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_tinker/tinker_rearm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Tinker.RearmStart", self:GetCaster() )
end