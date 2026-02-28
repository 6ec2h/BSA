legion_press_the_attack = class({})
LinkLuaModifier("modifier_legion_press_the_attack", "heroes/hero_legion/legion_press_the_attack/legion_press_the_attack", LUA_MODIFIER_MOTION_NONE)

function legion_press_the_attack:IsHiddenWhenStolen()
	return false
end

function legion_press_the_attack:GetAOERadius()
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_legion_commander_str10")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
			return self:GetSpecialValueFor("radius")
		end
	return 0
end

function legion_press_the_attack:GetBehavior()
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_legion_commander_str10")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function legion_press_the_attack:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_legion_commander_str10")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		
		local target_point = self:GetCursorPosition()
		local sound_target = "Hero_LegionCommander.PressTheAttack"
		--local sound_explosion = "Imba.WarlockShadowWordExplosion"
		local particle_aoe = "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
		local modifier_word = "modifier_legion_press_the_attack"

		local radius = ability:GetSpecialValueFor("radius")
		local duration = ability:GetSpecialValueFor("duration")

		EmitSoundOn(sound_target, caster)

	--	EmitSoundOnLocationWithCaster(target_point, sound_explosion, caster)

		local particle_aoe_fx = ParticleManager:CreateParticle(particle_aoe, PATTACH_WORLDORIGIN, caster)
		--ParticleManager:SetParticleControl(particle_aoe_fx, 0, target_point)
		--ParticleManager:SetParticleControl(particle_aoe_fx, 1, Vector(radius, 0, 0))
		--ParticleManager:SetParticleControl(particle_aoe_fx, 2, target_point)
		--ParticleManager:ReleaseParticleIndex(particle_aoe_fx)

		AddFOWViewer(caster:GetTeamNumber(), target_point, radius, 2, true)

		local units = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,unit in pairs(units) do
			unit:Purge(false, true, false, false, false)
			unit:AddNewModifier(caster, ability, modifier_word, {duration = duration})
		end
		
		

		Timers:CreateTimer(duration, function()
			StopSoundOn(sound_target, caster)
		end)
		else
		local sound_target = "Hero_LegionCommander.PressTheAttack"
		--local sound_explosion = "Imba.WarlockShadowWordExplosion"
		local particle_aoe = "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
		local modifier_word = "modifier_legion_press_the_attack"

		local radius = ability:GetSpecialValueFor("radius")
		local duration = ability:GetSpecialValueFor("duration")

		EmitSoundOn(sound_target, caster)
		
		local target = self:GetCursorTarget()
		target:Purge(false, true, false, false, false)
		target:AddNewModifier(caster, ability, modifier_word, {duration = duration})
			
		Timers:CreateTimer(duration, function()
			StopSoundOn(sound_target, caster)
		end)	
	end
end

----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------

modifier_legion_press_the_attack = class({})

function modifier_legion_press_the_attack:OnCreated()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.sound_good = "Hero_LegionCommander.PressTheAttack"
	self.particle_good = "particles/econ/items/legion/legion_fallen/legion_fallen_press.vpcf"
	
	if not self.ability then return end

	self.regen = self.ability:GetSpecialValueFor("regen")
	self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
	
	
	

	if IsServer() then

			EmitSoundOn(self.sound_good, self.parent)

			self.particle_good_fx = ParticleManager:CreateParticle(self.particle_good, PATTACH_ABSORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControl(self.particle_good_fx, 0, self.parent:GetAbsOrigin())
			ParticleManager:SetParticleControl(self.particle_good_fx, 2, self.parent:GetAbsOrigin())
			self:AddParticle(self.particle_good_fx, false, false, -1, false, false)
			
	end
end

function modifier_legion_press_the_attack:IsHidden() return false end
function modifier_legion_press_the_attack:IsPurgable() return true end
function modifier_legion_press_the_attack:IgnoreTenacity()	return true end


function modifier_legion_press_the_attack:OnDestroy()
	StopSoundOn(self.sound_good, self.parent)
end

function modifier_legion_press_the_attack:DeclareFunctions()
	local decFuncs = {
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return decFuncs
end

function modifier_legion_press_the_attack:GetModifierConstantHealthRegen()
	return self.regen
end

function modifier_legion_press_the_attack:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end