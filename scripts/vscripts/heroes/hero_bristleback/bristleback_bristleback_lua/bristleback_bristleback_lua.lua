LinkLuaModifier( "modifier_bristleback_bristleback_lua", "heroes/hero_bristleback/bristleback_bristleback_lua/bristleback_bristleback_lua", LUA_MODIFIER_MOTION_NONE )

bristleback_bristleback_lua							= class({})
modifier_bristleback_bristleback_lua					= class({})

function bristleback_bristleback_lua:GetIntrinsicModifierName()
	return "modifier_bristleback_bristleback_lua"
end

function modifier_bristleback_bristleback_lua:OnCreated()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
	self.side_angle					= self.ability:GetSpecialValueFor("side_angle")
	self.back_angle					= self.ability:GetSpecialValueFor("back_angle")
	self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")
end

function modifier_bristleback_bristleback_lua:OnRefresh()
	self.ability	= self:GetAbility()
	self.caster		= self:GetCaster()
	self.parent		= self:GetParent()
	
	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
	self.side_angle					= self.ability:GetSpecialValueFor("side_angle")
	self.back_angle					= self.ability:GetSpecialValueFor("back_angle")
	self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")

	if self:GetCaster():FindAbilityByName("special_bonus_unique_bristleback_1")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_unique_bristleback_1"):GetLevel() > 0 then 
			self.side_damage_reduction = self.back_damage_reduction
		end
	end
end

function modifier_bristleback_bristleback_lua:OnIntervalThink()
self:OnRefresh()
end


function modifier_bristleback_bristleback_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_bristleback_bristleback_lua:GetModifierIncomingDamage_Percentage(params)
	if self.parent:PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return 0 end

	local special_bonus_unique_bristleback_1 = self.caster:FindAbilityByName("special_bonus_unique_bristleback_1")

	if special_bonus_unique_bristleback_1 and special_bonus_unique_bristleback_1:GetLevel() > 0 then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
	
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle2)
		
		self.parent:EmitSound("Hero_Bristleback.Bristleback")
		
		return -self.back_damage_reduction
	end
	
	local forwardVector			= self.caster:GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self.caster:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)

	self.front_damage_reduction		= 0
	self.side_damage_reduction		= self.ability:GetSpecialValueFor("side_damage_reduction")
	self.back_damage_reduction		= self.ability:GetSpecialValueFor("back_damage_reduction")
	self.quill_release_threshold	= self.ability:GetSpecialValueFor("quill_release_threshold")

	if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
	
		local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle2)
		
		self.parent:EmitSound("Hero_Bristleback.Bristleback")
		
		return self.back_damage_reduction * (-1)
	elseif (difference <= (self.side_angle / 2)) or (difference >= (360 - (self.side_angle / 2))) then 

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		
		return self.side_damage_reduction * (-1)
	else
	
	
		return self.front_damage_reduction * (-1)
	end
end

function modifier_bristleback_bristleback_lua:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit ~= self.parent then return end
	if self.parent:PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS or not self.parent:HasAbility("bristleback_quill_spray_lua") or not self.parent:FindAbilityByName("bristleback_quill_spray_lua"):IsTrained() then return end
		
	local special_bonus_unique_bristleback_1 = self.caster:FindAbilityByName("special_bonus_unique_bristleback_1")
	
	if special_bonus_unique_bristleback_1 and special_bonus_unique_bristleback_1:GetLevel() > 0 then
		self:SetStackCount(self:GetStackCount() + params.damage)
		
		local quill_spray_ability = self.parent:FindAbilityByName("bristleback_quill_spray_lua")
		
		if quill_spray_ability and quill_spray_ability:IsTrained() and self:GetStackCount() >= self.quill_release_threshold then
			quill_spray_ability:OnSpellStart()
			self:SetStackCount(0)
			
			local special_bonus_unique_bristleback_4 = self.parent:FindAbilityByName("special_bonus_unique_bristleback_4")

			if special_bonus_unique_bristleback_4 and special_bonus_unique_bristleback_4:GetLevel() > 0 then
				local warpathModifier = self.parent:FindModifierByName("modifier_bristleback_warpath_lua")

				if warpathModifier then
					warpathModifier:OnAbilityFullyCast({
						ability = quill_spray_ability,
						unit = self.parent,
					})
				end
			end
		end
		return
	end

	if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "spectre_dispersion" then return end
	if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "frostivus2018_spectre_active_dispersion"  then return end
		
	local forwardVector			= self.caster:GetForwardVector()
	local forwardAngle			= math.deg(math.atan2(forwardVector.x, forwardVector.y))
			
	local reverseEnemyVector	= (self.caster:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
	local reverseEnemyAngle		= math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

	local difference = math.abs(forwardAngle - reverseEnemyAngle)

	if (difference <= (self.back_angle / 2)) or (difference >= (360 - (self.back_angle / 2))) then
		self:SetStackCount(self:GetStackCount() + params.damage)
		
		local quill_spray_ability = self.parent:FindAbilityByName("bristleback_quill_spray_lua")
		
		if quill_spray_ability and quill_spray_ability:IsTrained() and self:GetStackCount() >= self.quill_release_threshold then
			quill_spray_ability:OnSpellStart()
			self:SetStackCount(0)
		end
	end
end