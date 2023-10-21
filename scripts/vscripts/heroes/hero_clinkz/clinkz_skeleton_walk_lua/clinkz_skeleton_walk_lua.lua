LinkLuaModifier("modifier_clinkz_skeleton_walk_lua", "heroes/hero_clinkz/clinkz_skeleton_walk_lua/clinkz_skeleton_walk_lua", LUA_MODIFIER_MOTION_NONE)

clinkz_skeleton_walk_lua = class({})

function clinkz_skeleton_walk_lua:GetAbilityTextureName()
   return "clinkz_wind_walk"
end

function clinkz_skeleton_walk_lua:IsHiddenWhenStolen()
	return false
end

function clinkz_skeleton_walk_lua:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	EmitSoundOn("Hero_Clinkz.WindWalk", self:GetCaster())
	local particle_invis_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_windwalk.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_invis_fx, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_invis_fx, 1, self:GetCaster():GetAbsOrigin())

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_clinkz_skeleton_walk_lua", {duration = duration})
end

----------------------------------------------------------------------------------------------------------------

modifier_clinkz_skeleton_walk_lua = class({})

function modifier_clinkz_skeleton_walk_lua:IsHidden() return false end
function modifier_clinkz_skeleton_walk_lua:IsPurgable() return false end
function modifier_clinkz_skeleton_walk_lua:IsDebuff() return false end

function modifier_clinkz_skeleton_walk_lua:OnCreated()
end

function modifier_clinkz_skeleton_walk_lua:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVISIBLE] = true
	}
end

function modifier_clinkz_skeleton_walk_lua:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_clinkz_skeleton_walk_lua:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_EVENT_ON_ATTACK
	}
end

function modifier_clinkz_skeleton_walk_lua:GetModifierInvisibilityLevel()
	return 1
end

function modifier_clinkz_skeleton_walk_lua:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_ms")
end

function modifier_clinkz_skeleton_walk_lua:OnAbilityExecuted(keys)
	if IsServer() then             
		if self:GetParent() == keys.unit then            
			self:Destroy()        
		end        
	end
end

function modifier_clinkz_skeleton_walk_lua:OnAttack(keys)
	if IsServer() then
		if self:GetParent() == keys.attacker then
			self:Destroy()
		end
	end
end