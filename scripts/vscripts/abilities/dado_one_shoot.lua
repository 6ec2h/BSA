LinkLuaModifier("modifier_dado_one_shoot", "abilities/dado_one_shoot", LUA_MODIFIER_MOTION_NONE)

dado_one_shoot = class({})

function dado_one_shoot:Precache(context)
	PrecacheResource("particle", "particles/dado_arc.vpcf", context)
	PrecacheResource("particle", "particles/dado_bolt.vpcf", context)
end

function dado_one_shoot:GetIntrinsicModifierName()
	return "modifier_dado_one_shoot"
end

function dado_one_shoot:OnSpellStart()
	self:PlayEffects()

	local target = self:GetCursorTarget()

	for modNum = 0, target:GetModifierCount() - 1 do
		local modName = target:GetModifierNameByIndex(modNum)
		local mod = target:FindModifierByName(modName)

		if mod and mod:HasFunction(MODIFIER_PROPERTY_MIN_HEALTH) then
			target:RemoveModifierByName(modName)
		end
	end

	target:Kill(nil, self:GetCaster())

	self:GetCaster():FindModifierByName("modifier_dado_one_shoot").extraSpeed = 600
end

function dado_one_shoot:PlayEffects()
	local caster = self:GetCaster()
	local casterPos = caster:GetAbsOrigin()

	local target = self:GetCursorTarget()
	local targetPos = target:GetAbsOrigin()
	
	for _ = 1, 3 do
		local particle = ParticleManager:CreateParticle("particles/dado_arc.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(particle, 6, caster, PATTACH_POINT_FOLLOW, "attach_attack2", casterPos, true)
		ParticleManager:SetParticleControlEnt(particle, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", targetPos, true)

		ParticleManager:SetParticleControl(particle, 6, casterPos)
		ParticleManager:SetParticleControl(particle, 5, targetPos)
		
		Timers:CreateTimer(0.4, function()
			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex(particle)
		end)
	end
	
	local particle = ParticleManager:CreateParticle("particles/dado_bolt.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, targetPos + Vector(0, 0, 250))
	ParticleManager:SetParticleControlEnt(particle,	1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
	Timers:CreateTimer(0.3, function()
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:ReleaseParticleIndex(particle)
	end)

	EmitSoundOn("Hero_Enigma.MaleficeTick", target)
end

modifier_dado_one_shoot = class({})

function modifier_dado_one_shoot:IsHidden() return true end
function modifier_dado_one_shoot:IsPurgable() return false end

function modifier_dado_one_shoot:OnCreated()
	if not IsServer() then return end

	self.extraSpeed = 0

	self:StartIntervalThink(1)
end

function modifier_dado_one_shoot:OnIntervalThink()
	self.extraSpeed = self.extraSpeed + 7
end

function modifier_dado_one_shoot:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
end

function modifier_dado_one_shoot:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end

function modifier_dado_one_shoot:GetModifierProvidesFOWVision()
	return 1
end

function modifier_dado_one_shoot:GetModifierMoveSpeedBonus_Constant()
	return self.extraSpeed
end

function modifier_dado_one_shoot:GetModifierIgnoreMovespeedLimit()
	return 1
end