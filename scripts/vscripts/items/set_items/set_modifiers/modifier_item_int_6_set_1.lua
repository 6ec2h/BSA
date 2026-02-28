modifier_item_int_6_set_1 = class({})

function modifier_item_int_6_set_1:IsHidden()
	return true
end

function modifier_item_int_6_set_1:IsPurgable()
	return false
end

function modifier_item_int_6_set_1:RemoveOnDeath()
	return false
end

function modifier_item_int_6_set_1:OnCreated( kv )
end

function modifier_item_int_6_set_1:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}
	return funcs
end

function modifier_item_int_6_set_1:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit ~= self:GetParent() then
			return 0
		end
		local Ability = params.ability
		if Ability == nil then
			return 0
		end

		if Ability:IsRefreshable() and Ability:IsItem() == false and RandomInt(1, 100) <= self:GetCaster():GetLevel() then
			Ability:EndCooldown()
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1, 2, 1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			EmitSoundOn( "Bogduggs.LuckyFemur", self:GetParent() )
		end
	end
	return 0
end