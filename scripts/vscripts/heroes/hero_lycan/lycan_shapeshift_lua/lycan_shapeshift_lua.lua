lycan_shapeshift_lua = class({})
LinkLuaModifier("modifier_lycan_shapeshift_lua_transform_stun", "heroes/hero_lycan/lycan_shapeshift_lua/lycan_shapeshift_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_lua_transform", "heroes/hero_lycan/lycan_shapeshift_lua/lycan_shapeshift_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_lua", "heroes/hero_lycan/lycan_shapeshift_lua/lycan_shapeshift_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lycan_shapeshift_lua_certain_crit", "heroes/hero_lycan/lycan_shapeshift_lua/lycan_shapeshift_lua", LUA_MODIFIER_MOTION_NONE)

function lycan_shapeshift_lua:GetBehavior()
	local abil = self:GetCaster():FindAbilityByName("special_bonus_lycan_tal4")
	if abil ~= nil and abil:GetLevel() > 0 then 
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function lycan_shapeshift_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local sound_cast = "Hero_Lycan.Shapeshift.Cast"
	local response_cast = "lycan_lycan_ability_shapeshift_"	
	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_lycan_tal4")
	if abil ~= nil and abil:GetLevel() > 0 then 
		target = self:GetCursorTarget()
	else
		target = caster
	end
	

	local transformation_time = 1
	local duration = ability:GetSpecialValueFor("duration")	
	
	target:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
	
	local random_sound = RandomInt(1,10)
	local correct_sound_num = ""
	if random_sound < 10 then
		correct_sound_num = "0"..tostring(random_sound)
	else
		correct_sound_num = random_sound
	end
	
	
	local response_cast = response_cast .. correct_sound_num 	
	local who_let_the_dogs_out = 10
	
	if RollPercentage(who_let_the_dogs_out) then
		EmitSoundOn("Imba.LycanDogsOut", target)
	else
		EmitSoundOn(response_cast, target)
	end
	
	EmitSoundOn(sound_cast, target)
	
	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_cast.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0 , target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1 , target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 2 , target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 3 , target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)

	target:AddNewModifier(caster, ability, "modifier_lycan_shapeshift_lua_transform_stun", {duration = transformation_time})
	
	Timers:CreateTimer(transformation_time, function()
		target:AddNewModifier(caster, ability, "modifier_lycan_shapeshift_lua_transform", {duration = duration + 1})
	end)	
end

--------------------------------------------------------------------------------------------

modifier_lycan_shapeshift_lua_transform_stun = class({})

function modifier_lycan_shapeshift_lua_transform_stun:CheckState()	
	local state = {[MODIFIER_STATE_STUNNED] = true}
	return state	
end

function modifier_lycan_shapeshift_lua_transform_stun:IsHidden()
	return true
end

--------------------------------------------------------------------------------------------

modifier_lycan_shapeshift_lua_transform = class({})

function modifier_lycan_shapeshift_lua_transform:DeclareFunctions()	
	local decFuncs = {MODIFIER_PROPERTY_MODEL_CHANGE}	
	return decFuncs	
end

function modifier_lycan_shapeshift_lua_transform:GetModifierModelChange()
	return "models/heroes/lycan/lycan_wolf.vmdl"
end

function modifier_lycan_shapeshift_lua_transform:OnCreated()
	local duration = self:GetAbility():GetSpecialValueFor("duration")	
	if IsServer() then    	
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lycan_shapeshift_lua", {duration = duration + 1})
	end
end

function modifier_lycan_shapeshift_lua_transform:OnDestroy()
    if IsServer() then    	
    	local response_sound = "lycan_lycan_ability_revert_0" ..RandomInt(1,3)	
    	
    	EmitSoundOn(response_sound, self:GetParent())
    	
    	local particle_revert_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_shapeshift_revert.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    	ParticleManager:SetParticleControl(particle_revert_fx, 0, self:GetParent():GetAbsOrigin())
    	ParticleManager:SetParticleControl(particle_revert_fx, 3, self:GetParent():GetAbsOrigin())
    end
end

function modifier_lycan_shapeshift_lua_transform:IsHidden()
	return false
end

function modifier_lycan_shapeshift_lua_transform:IsPurgable()
	return false
end

function modifier_lycan_shapeshift_lua_transform:IsDebuff()
	return false
end

--------------------------------------------------------------------------------------

modifier_lycan_shapeshift_lua = class({})

function modifier_lycan_shapeshift_lua:IsHidden()
	return true
end

function modifier_lycan_shapeshift_lua:IsPurgable()
	return false
end

function modifier_lycan_shapeshift_lua:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "mult" )
	self.ms = self:GetAbility():GetSpecialValueFor( "ms" )
	self.hp = self:GetAbility():GetSpecialValueFor( "hp" )
end

function modifier_lycan_shapeshift_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
	return funcs
end

function modifier_lycan_shapeshift_lua:GetModifierMoveSpeed_AbsoluteMin()
	return self.ms
end

function modifier_lycan_shapeshift_lua:GetModifierHealthBonus()
	return self.hp
end

function modifier_lycan_shapeshift_lua:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if params.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if RandomInt(0, 100)<self.crit_chance then
			self.record = params.record
			return self.crit_mult
		end
	end
end