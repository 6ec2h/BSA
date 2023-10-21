wraith_king_reincarnation_lua = class({})
LinkLuaModifier( "modifier_wraith_king_reincarnation_lua", "heroes/hero_skeleton/wraith_king_reincarnation_lua/wraith_king_reincarnation_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wraith_king_reincarnation_lua_debuff", "heroes/hero_skeleton/wraith_king_reincarnation_lua/wraith_king_reincarnation_lua", LUA_MODIFIER_MOTION_NONE )

function wraith_king_reincarnation_lua:GetIntrinsicModifierName()
	return "modifier_wraith_king_reincarnation_lua"
end

function wraith_king_reincarnation_lua:TheWillOfTheKing( OnDeathKeys, BuffInfo )
	local unit = OnDeathKeys.unit
	local reincarnate = OnDeathKeys.reincarnate
	self.slow_radius = BuffInfo.ability:GetSpecialValueFor( "slow_radius" )
	self.slow_duration = BuffInfo.ability:GetSpecialValueFor( "reincarnate_time" )
	
	
	if reincarnate and (not BuffInfo.caster:HasModifier("modifier_aegis")) then
		BuffInfo.reincarnation_death = true
		BuffInfo.ability:UseResources(true, false, false, true)

		Timers:CreateTimer(3.1,function() 
			unit:AddNewModifier( unit, BuffInfo.ability, "modifier_invulnerable", { duration = 3 } )
		end)

		local enemies = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetOrigin(), nil, self.slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(
				unit,
				BuffInfo.ability,
				"modifier_wraith_king_reincarnation_lua_debuff",
				{ duration = self.slow_duration }
			)
	
			local abil = unit:FindAbilityByName("npc_dota_hero_skeleton_king_tal4")
			if abil ~= nil and abil:GetLevel() > 0 then 
				-- ApplyDamage({attacker = unit, victim = enemy, ability = BuffInfo.ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
				
				LaunchWraithblastProjectile(BuffInfo.caster, BuffInfo.ability, unit, enemy, true, true)
				
				unit:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
			end
		end
		self:PlayEffects(unit)
	else
		BuffInfo.reincarnation_death = false     
	end
end

function LaunchWraithblastProjectile(caster, ability, source, target)   
	local wraithblast_projectile
	wraithblast_projectile = {Target = target,
							  Source = source,
							  Ability = ability,
							  EffectName = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf"    ,
							  iMoveSpeed = 700,
							  bDodgeable = true, 
							  bVisibleToEnemies = true,
							  bReplaceExisting = false,
							  bProvidesVision = false,  
							  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
	}
	ProjectileManager:CreateTrackingProjectile(wraithblast_projectile)
end

function wraith_king_reincarnation_lua:OnProjectileHit_ExtraData(target, location)
	if not target then
		return nil
	end

	local caster = self:GetCaster()
	local ability = self

	local damage = caster:GetAverageTrueAttackDamage(nil)
	EmitSoundOn("Hero_SkeletonKing.Hellfire_BlastImpact" , caster)    

	if target:IsMagicImmune() then
		return nil
	end

	ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability})
end

function wraith_king_reincarnation_lua:PlayEffects(unit)
	local effect_cast = ParticleManager:CreateParticle(  "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_ABSORIGIN, unit )
	ParticleManager:SetParticleControl( effect_cast, 0, unit:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.reincarnate_time, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_SkeletonKing.Reincarnate", unit )
end

----------------------------------------------------------------------------------------

modifier_wraith_king_reincarnation_lua_debuff = class({})

function modifier_wraith_king_reincarnation_lua_debuff:IsHidden()
	return false
end

function modifier_wraith_king_reincarnation_lua_debuff:IsDebuff()
	return true
end

function modifier_wraith_king_reincarnation_lua_debuff:IsStunDebuff()
	return false
end

function modifier_wraith_king_reincarnation_lua_debuff:IsPurgable()
	return true
end

function modifier_wraith_king_reincarnation_lua_debuff:OnCreated( kv )
	self.move_slow = self:GetAbility():GetSpecialValueFor( "movespeed" ) -- special value
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attackslow_tooltip" ) -- special value
end

function modifier_wraith_king_reincarnation_lua_debuff:OnRefresh( kv )
	self.move_slow = self:GetAbility():GetSpecialValueFor( "movespeed" ) -- special value
	self.attack_slow = self:GetAbility():GetSpecialValueFor( "attackslow_tooltip" ) -- special value
end

function modifier_wraith_king_reincarnation_lua_debuff:OnDestroy( kv )

end

function modifier_wraith_king_reincarnation_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_wraith_king_reincarnation_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end

function modifier_wraith_king_reincarnation_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end


function modifier_wraith_king_reincarnation_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"
end

function modifier_wraith_king_reincarnation_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

----------------------------------------------------------------------------------------

modifier_wraith_king_reincarnation_lua = class({})

function modifier_wraith_king_reincarnation_lua:IsHidden()
	return true
end

function modifier_wraith_king_reincarnation_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()   
	self.reincarnate_time = self:GetAbility():GetSpecialValueFor( "reincarnate_time" )

	if IsServer() then
		self.can_die = false
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_wraith_king_reincarnation_lua:OnRefresh()
	self:OnCreated()
end


function modifier_wraith_king_reincarnation_lua:OnIntervalThink()
	if not self.ability or self.ability:IsNull() then self:Destroy() return end
	if (self.ability:IsOwnersManaEnough()) and (self.ability:IsCooldownReady()) and (not self.caster:HasModifier("modifier_aegis")) then
		self.can_die = false
	else
		self.can_die = true
	end
end

function modifier_wraith_king_reincarnation_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_REINCARNATION,                      
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_EVENT_ON_DEATH,
	}
end

function modifier_wraith_king_reincarnation_lua:ReincarnateTime()
	if IsServer() then
		if not self.can_die and self.caster:IsRealHero() then
			return self.reincarnate_time
		end
		return nil
	end
end

function modifier_wraith_king_reincarnation_lua:GetActivityTranslationModifiers()
	if self.reincarnate_time then
		return "reincarnate"
	end
	return nil
end

function modifier_wraith_king_reincarnation_lua:OnDeath(keys)
	if IsServer() then
		local unit = keys.unit
		local reincarnate = keys.reincarnate
		if self:GetParent() == unit then
			wraith_king_reincarnation_lua:TheWillOfTheKing( keys, self )
		end
	end
end















