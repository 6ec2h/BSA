LinkLuaModifier( "modifier_spider_spray", "abilities/creeps/spider_spray", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spider_spray_stack", "abilities/creeps/spider_spray", LUA_MODIFIER_MOTION_NONE )

spider_spray = class({})

function spider_spray:GetIntrinsicModifierName()
	return "modifier_spider_spray"
end

-------------------------------------
modifier_spider_spray = class({})

function modifier_spider_spray:IsHidden()
	return true
end

function modifier_spider_spray:IsDebuff()
	return false
end

function modifier_spider_spray:IsPurgable()
	return false
end

function modifier_spider_spray:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.stack_damage = self:GetAbility():GetSpecialValueFor("stack_damage")
	self.base_damage = self:GetAbility():GetSpecialValueFor("damage")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_spider_spray:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_spider_spray:OnDeath(keys)
	if not IsServer() then return end
	if self:GetParent() == keys.unit then
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
	local damageTable = {
		attacker = self:GetParent(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	for _,enemy in pairs(enemies) do
		local stack = 0
		local modifier = enemy:FindModifierByName("modifier_spider_spray_stack")
		if modifier ~= nil then
			stack = modifier:GetStackCount()
			modifier:IncrementStackCount()
		end
		damageTable.victim = enemy
		damageTable.damage = self.base_damage + stack*self.stack_damage
		ApplyDamage( damageTable )

		if modifier == nil then
			mod = enemy:AddNewModifier(self:GetParent(), self, "modifier_spider_spray_stack", {duration = self.duration})
			mod:IncrementStackCount()
		end
		
	end
	self:PlayEffects()
	end
end

function modifier_spider_spray:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray_c.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( "Hero_Alchemist.AcidSpray", self:GetParent() )
end

-----------------------------------------------------------

modifier_spider_spray_stack = class({})

function modifier_spider_spray_stack:IsHidden()
	return false
end

function modifier_spider_spray_stack:IsPurgable()
	return false
end