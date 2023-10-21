LinkLuaModifier( "modifier_venomancer_poison_tick", "heroes/hero_venomancer/venomancer_poison_tick", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_venomancer_poison_tick_debuff", "heroes/hero_venomancer/venomancer_poison_tick", LUA_MODIFIER_MOTION_NONE )

venomancer_poison_tick = class({})

function venomancer_poison_tick:GetIntrinsicModifierName() 
    return 'modifier_venomancer_poison_tick'
end

-------------------------------------------------------------------------------------------

modifier_venomancer_poison_tick = class({})

function modifier_venomancer_poison_tick:IsHidden()
	return true
end

function modifier_venomancer_poison_tick:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_venomancer_poison_tick:OnAttackLanded( params )
	if IsServer() then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end
		if pass then
			local modifier = params.target:FindModifierByName("modifier_venomancer_poison_tick_debuff")
			if modifier == nil then
				params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_venomancer_poison_tick_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
			else
				modifier:IncrementStackCount()
			end
		end
	end
end

----------------------------------------------------------------------------------------


modifier_venomancer_poison_tick_debuff = class({})

function modifier_venomancer_poison_tick_debuff:IsHidden()
	return false
end

function modifier_venomancer_poison_tick_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_venomancer_poison_tick_debuff:OnCreated()
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if IsServer() then
		local owner = self:GetParent()
		owner.orchid_damage_storage = owner.orchid_damage_storage or 0
	end
end

function modifier_venomancer_poison_tick_debuff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_venomancer_poison_tick_debuff:GetModifierPhysicalArmorBonus()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("armor") * (-1)
end

function modifier_venomancer_poison_tick_debuff:GetModifierMagicalResistanceBonus()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("magic_armor") * (-1)
end

function modifier_venomancer_poison_tick_debuff:OnTakeDamage(keys)
	if IsServer() then
		local owner = self:GetParent()
		local target = keys.unit
		if owner == target and keys.attacker == self:GetCaster() then
			owner.orchid_damage_storage = owner.orchid_damage_storage + keys.damage
		end
		if self:GetStackCount() == self:GetAbility():GetSpecialValueFor("count") then
			self:Destroy()
		end
	end
end

function modifier_venomancer_poison_tick_debuff:OnDestroy()
	if IsServer() then
		local owner = self:GetParent()
		local ability = self:GetAbility()
		local caster = ability:GetCaster()
		local damage = self:GetAbility():GetSpecialValueFor("damage")
		local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_venomancer_3")
		if ability ~= nil and ability:GetLevel() > 0 then 
			damage = damage + 15
		end

		if owner.orchid_damage_storage > 0 then
			local damage = owner.orchid_damage_storage * damage * 0.01
			ApplyDamage({attacker = caster, victim = owner, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

			local orchid_end_pfx = ParticleManager:CreateParticle("particles/items2_fx/orchid_pop.vpcf", PATTACH_OVERHEAD_FOLLOW, owner)
			ParticleManager:SetParticleControl(orchid_end_pfx, 0, owner:GetAbsOrigin())
			ParticleManager:SetParticleControl(orchid_end_pfx, 1, Vector(100, 0, 0))
			ParticleManager:ReleaseParticleIndex(orchid_end_pfx)
		end
		self:GetParent().orchid_damage_storage = nil
	end
end
