LinkLuaModifier("modifier_marci_passive_hit", "heroes/hero_marci/marci_rebound_lua/marci_rebound_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marci_passive_hit_ready", "heroes/hero_marci/marci_rebound_lua/marci_rebound_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_marci_passive_hit_armor", "heroes/hero_marci/marci_rebound_lua/marci_rebound_lua", LUA_MODIFIER_MOTION_NONE)

marci_rebound_lua = class({})

function marci_rebound_lua:GetIntrinsicModifierName()
	return "modifier_marci_passive_hit"
end

----------------------------------------------------------------------------------------------------

modifier_marci_passive_hit = class({})

function modifier_marci_passive_hit:IsHidden()
	return true
end

function modifier_marci_passive_hit:RemoveOnDeath()
	return false
end

function modifier_marci_passive_hit:IsPurgable()
	return false
end

function modifier_marci_passive_hit:OnCreated()
	self:StartIntervalThink(0.1)
end

function modifier_marci_passive_hit:OnIntervalThink()
	if IsServer() and self:GetAbility() and self:GetCaster():IsRealHero() and self:GetCaster():IsAlive() then
		if self:GetAbility():IsCooldownReady() then
			if not self:GetCaster():HasModifier("modifier_marci_passive_hit_ready") then
				self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_passive_hit_ready", {})
			end
		end
	end
end

--------------------------------------------------------------------------------

modifier_marci_passive_hit_ready = class({})

function modifier_marci_passive_hit_ready:IsHidden()
	return false
end

function modifier_marci_passive_hit_ready:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_marci_passive_hit_ready:OnAttackStart( params )
	if self:GetAbility() then
		local parent = self:GetParent()
		local target = params.target
		if (parent == params.attacker) and (target:GetTeamNumber() ~= parent:GetTeamNumber()) and (target.IsCreep or target.IsHero) then
			if not parent:PassivesDisabled() then
			
				self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
				local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_marci_3")
				if ability ~= nil and ability:GetLevel() > 0 then 
					self.bonus_damage = self.bonus_damage + 80
				end

			else
				self.bonus_damage = 0
			end
		end
	end
end

function modifier_marci_passive_hit_ready:OnAttackLanded( params )
	if self:GetAbility() then
		local parent = self:GetParent()
		if params.attacker == parent and ( not parent:IsIllusion() ) then
			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("duration")})
				target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_passive_hit_armor", {duration = self:GetAbility():GetSpecialValueFor("duration")})
				EmitSoundOn("Hero_Tusk.c.Target", parent) 
				local particle = ParticleManager:CreateParticle("particles/marci_punch.vpcf", PATTACH_ABSORIGIN, parent)
				ParticleManager:SetParticleControl(particle, 2, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
			end
			self:GetAbility():UseResources( false,false, false, true )
			self:Destroy()
		end
	end
end

function modifier_marci_passive_hit_ready:GetModifierPreAttack_BonusDamage(params)
	self.bonus_damage = self.bonus_damage or 0
	return self.bonus_damage
end

-----------------------------------------------------

modifier_marci_passive_hit_armor = class({})

function modifier_marci_passive_hit_armor:IsHidden()
	return true
end

function modifier_marci_passive_hit_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_marci_passive_hit_armor:GetModifierPhysicalArmorBonus(params)
	return -self:GetAbility():GetSpecialValueFor("armor")
end
