LinkLuaModifier( "modifier_brute_spirits", "abilities/creeps/brute_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_brute_spirits_effect", "abilities/creeps/brute_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_brute_spirits_effect_hit", "abilities/creeps/brute_spirits", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_dummy_spirit", "abilities/creeps/brute_spirits", LUA_MODIFIER_MOTION_NONE)

brute_spirits = class({})

function brute_spirits:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", context )
end

function brute_spirits:OnSpellStart()
	EmitSoundOn("Hero_Ursa.Earthshock", self:GetCaster())
	self.duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_brute_spirits",{ duration = self.duration })
end

-----------------------------------------------------------------------------------------------------------
modifier_brute_spirits = class({})

function modifier_brute_spirits:IsHidden()	
	return true
end

function modifier_brute_spirits:IsPurgable()
	return false
end

function modifier_brute_spirits:OnCreated()	
	self.spirits_startTime = GameRules:GetGameTime()
	self.spirits_right = 0
	self.spirits_left = 0
	self.spirits_list_right = {}
	self.spirits_list_left = {}
	self.spirits_radius = self:GetAbility():GetSpecialValueFor("radius")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.count = self:GetAbility():GetSpecialValueFor("count")
	self.spirits_movementFactor	= 0
	self.ability = self:GetAbility()
	
	self:StartIntervalThink(0.03)
end

function modifier_brute_spirits:OnIntervalThink()
	if not IsServer() then return end
	self.caster_pos = self:GetCaster():GetAbsOrigin()
	
	local elapsedTime = GameRules:GetGameTime() - self.spirits_startTime
	
	if self:GetCaster():GetUnitName() == 'npc_invoker_boss' then
		self:CreateSpiritsLeft(self.spirits_radius, self.count, 1)
	else
		self:CreateSpiritsLeft(self.spirits_radius, self.count, 1)
		self:CreateSpiritsRight(self.spirits_radius - 400, self.count, -1)
	end
end

function modifier_brute_spirits:CreateSpiritsLeft(radius, count, direction)
	if self.spirits_left < count + 1 then
		local newSpirit = CreateUnitByName("npc_dummy_unit", self.caster_pos, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		newSpirit:AddNewModifier(self:GetCaster(), self, "modifier_dummy_spirit",{} )
		newSpirit:AddNewModifier(self:GetCaster(), self.ability, "modifier_brute_spirits_effect",{ duration = self.duration })
		
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )

		local spiritIndex = self.spirits_left + 1
		newSpirit.spirit_index = spiritIndex
		self.spirits_left = spiritIndex
		self.spirits_list_left[spiritIndex] = newSpirit
	end

	local deltaRadius = self.spirits_movementFactor * 150 * 0.03
	local currentRadius = radius + deltaRadius
	currentRadius = math.min(math.max(currentRadius, radius), 650)

	local currentRotationAngle = (GameRules:GetGameTime() - self.spirits_startTime) * 100
	local rotationAngleOffset = 360 / count

	local numSpiritsAlive = 0

	for k,v in pairs(self.spirits_list_left) do
		numSpiritsAlive = numSpiritsAlive + 1

		local rotationAngle = (currentRotationAngle - rotationAngleOffset * (k - 1)) * direction

		local relPos = Vector(0, currentRadius, 0)
		relPos = RotatePosition(Vector(0,0,0), QAngle(0, rotationAngle, 0), relPos)

		local absPos = GetGroundPosition(relPos + self.caster_pos, v)
		v:SetAbsOrigin(absPos)
		v:SetAngles(0, rotationAngle, 0)
	end

	if self.spirits_left == self.count and numSpiritsAlive == 0 then
		return
	end
end

function modifier_brute_spirits:CreateSpiritsRight(radius, count, direction)
	if self.spirits_right < count + 1 then
		local newSpirit = CreateUnitByName("npc_dummy_unit", self.caster_pos, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
		newSpirit:AddNewModifier(self:GetCaster(), self, "modifier_dummy_spirit",{} )
		newSpirit:AddNewModifier(self:GetCaster(), self.ability, "modifier_brute_spirits_effect",{ duration = self.duration })
		
		local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_earth_spirit/espirit_rollingboulder.vpcf", PATTACH_ABSORIGIN_FOLLOW, newSpirit )

		local spiritIndex = self.spirits_right + 1
		newSpirit.spirit_index = spiritIndex
		self.spirits_right = spiritIndex
		self.spirits_list_right[spiritIndex] = newSpirit
	end

	local deltaRadius = self.spirits_movementFactor * 150 * 0.03
	local currentRadius = radius + deltaRadius
	currentRadius = math.min(math.max(currentRadius, radius), 650)

	local currentRotationAngle = (GameRules:GetGameTime() - self.spirits_startTime) * 100
	local rotationAngleOffset = 360 / count

	local numSpiritsAlive = 0

	for k,v in pairs(self.spirits_list_right) do
		numSpiritsAlive = numSpiritsAlive + 1

		local rotationAngle = (currentRotationAngle - rotationAngleOffset * (k - 1)) * direction

		local relPos = Vector(0, currentRadius, 0)
		relPos = RotatePosition(Vector(0,0,0), QAngle(0, rotationAngle, 0), relPos)

		local absPos = GetGroundPosition(relPos + self.caster_pos, v)
		v:SetAbsOrigin(absPos)
		v:SetAngles(0, rotationAngle, 0)
	end

	if self.spirits_right == self.count and numSpiritsAlive == 0 then
		return
	end
end

----------------------------------------------------

modifier_brute_spirits_effect = class({})

function modifier_brute_spirits_effect:IsPurgable()
	return false
end

function modifier_brute_spirits_effect:OnCreated(params)
	if IsServer() then
		self.caster = self:GetCaster()
		self:StartIntervalThink(0.1)
	end
end

function modifier_brute_spirits_effect:OnIntervalThink()
	if IsServer() then 
		if not self.caster:IsAlive() then
			self:OnDestroy()
			return
		end
	
		self.damage = self:GetAbility():GetSpecialValueFor("damage")
		
		local spirit = self:GetParent()
		
		local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), spirit:GetAbsOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if enemies ~= nil and #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if not enemy:HasModifier("modifier_brute_spirits_effect_hit") then
					enemy:AddNewModifier(self.caster, nil, "modifier_brute_spirits_effect_hit", {duration = 0.25})
					ApplyDamage({
					victim = enemy,
					damage = enemy:GetMaxHealth() / 100 * self.damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					attacker = self:GetCaster()})	
				end
			end	
		end
	end
end

function modifier_brute_spirits_effect:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

---------------------------------------------------------

modifier_brute_spirits_effect_hit = class({})

function modifier_brute_spirits_effect_hit:IsHidden()
	return true
end

function modifier_brute_spirits_effect_hit:OnCreated() 
	if IsServer() then
		local target = self:GetParent()
		EmitSoundOn("Hero_Wisp.Spirits.TargetCreep", target)
		self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_guardian_explosion_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	end
end

function modifier_brute_spirits_effect_hit:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pfx, false)
	end
end

--------------------------------------------------

modifier_dummy_spirit = class({})

function modifier_dummy_spirit:IsHidden()
    return true
end

function modifier_dummy_spirit:IsPurgable()
    return false
end

function modifier_dummy_spirit:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end

