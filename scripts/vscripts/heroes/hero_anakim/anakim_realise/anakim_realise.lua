LinkLuaModifier( "modifier_anakim_wisp", "heroes/hero_anakim/anakim_wisp/anakim_wisp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_anakim_wisp_handler", "heroes/hero_anakim/anakim_wisp/anakim_wisp", LUA_MODIFIER_MOTION_NONE )

anakim_realise = class({})

function anakim_realise:CastFilterResultTarget( target )
	if IsServer() then
		self.stack = true
		self.ability = true
		local modifier = self:GetCaster():FindModifierByName("modifier_anakim_wisp")
		if modifier then
			local modifier_stacks = modifier:GetStackCount()
			if modifier_stacks == 0 then
				self.stack = false
				return UF_FAIL_CUSTOM
			else
				return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
			end	
		else
			self.ability = false
			return UF_FAIL_CUSTOM
		end
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
	end
end

function anakim_realise:GetCustomCastErrorTarget(target)
	if not self.ability then
		return "#anakim_wisp_not_learn"
	end
	if not self.stack then
		return "#anakim_wisp_not_stack"
	end
end

function anakim_realise:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local delay = self:GetSpecialValueFor("delay")
	self.stack_damage = self:GetSpecialValueFor("stack_damage")
	self.soul_stack_damage = 0
	local modifier = caster:FindModifierByName("modifier_anakim_wisp")
	if modifier then
		local modifier_stacks = modifier:GetStackCount()
		if modifier_stacks > 0 then
		local pulse = 0
		Timers:CreateTimer(0, function()
			if pulse < modifier_stacks then
				pulse = pulse + 1
				EmitSoundOn( "Hero_SkywrathMage.ConcussiveShot.Cast", caster )
				self.soul_stack_damage = self.soul_stack_damage + self.stack_damage 
		
				modifier:DecrementStackCount()
				local soul_defence = modifier:GetAbility():GetSpecialValueFor("soul_defense")	
				
				local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_anakim_tal3")
				if ability ~= nil and ability:GetLevel() > 0 then 
					soul_defence = soul_defence + ability:GetSpecialValueFor("value")
				end
			
				modifier.shield = modifier.shield - soul_defence
					
				if modifier.shield < 0 then
					modifier.shield = 0
				end
				local info = {
					Target = target,
					Source = caster,
					Ability = self,	
					EffectName = "particles/anakim/anakim_realise.vpcf",
					iMoveSpeed = 900,
					ExtraData = {
						additional_damage = self.soul_stack_damage
					}
				}
				ProjectileManager:CreateTrackingProjectile(info)
				return delay
			else
				return nil
			end
		end)
		end
	end	
end

function anakim_realise:OnProjectileHit_ExtraData( target, location, extra )
	if not target then return end
	local damage = self:GetSpecialValueFor( "damage" )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_anakim_tal7")
	if ability ~= nil and ability:GetLevel() > 0 then 
		damage = damage + ability:GetSpecialValueFor("value")
	end
	
	local damageTable = {
		attacker = self:GetCaster(),
		damage_type = self:GetAbilityDamageType(),
		ability = self,
	}
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_anakim_tal8")
	if ability ~= nil and ability:GetLevel() > 0 then 
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for _,enemy in pairs(enemies) do
			damageTable.victim = enemy
			damageTable.damage = damage + extra.additional_damage
			ApplyDamage( damageTable )
		end
	else
		damageTable.victim = target
		damageTable.damage = damage + extra.additional_damage
		ApplyDamage( damageTable )
	end

	EmitSoundOn("Hero_SkywrathMage.ConcussiveShot.Target", target )
end