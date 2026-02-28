meepo_earthbind_lua = class({})
LinkLuaModifier( "modifier_meepo_earthbind_lua", "heroes/hero_meepo/meepo_earthbind_lua/meepo_earthbind_lua", LUA_MODIFIER_MOTION_NONE )

function meepo_earthbind_lua:OnSpellStart()
	local caster = self:GetCaster()
	
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
		target = enemies[1]
		local projectile_speed = self:GetSpecialValueFor( "net_speed" )
		local projectile_name = "particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf"--"particles/units/heroes/hero_siren/siren_net_projectile.vpcf"
		local info = {
			Target = target,
			Source = caster,
			Ability = self,	
			
			EffectName = projectile_name,
			iMoveSpeed = projectile_speed,
			bDodgeable = true,                           -- Optional
			ExtraData = {
				fake = 0,
			}
		}
		ProjectileManager:CreateTrackingProjectile(info)

		local sound_cast = "Hero_Meepo.Earthbind.Cast"
		EmitSoundOn( sound_cast, caster )
	end
end

function meepo_earthbind_lua:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end
	if data.fake==1 then return end

	if target:IsMagicImmune() then return end

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- ensnare
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_meepo_earthbind_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	local sound_cast = "Hero_Meepo.Earthbind.Target"
	EmitSoundOn( sound_cast, target )
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_meepo_earthbind_lua = class({})

function modifier_meepo_earthbind_lua:IsHidden()
	return false
end

function modifier_meepo_earthbind_lua:IsDebuff()
	return true
end

function modifier_meepo_earthbind_lua:IsStunDebuff()
	return false
end

function modifier_meepo_earthbind_lua:IsPurgable()
	return true
end

function modifier_meepo_earthbind_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_meepo_earthbind_lua:OnCreated( kv )
	local talent_ability = self:GetCaster():FindAbilityByName("special_bonus_meepo_int1")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		self:StartIntervalThink(0.5)
	end
end

function modifier_meepo_earthbind_lua:OnIntervalThink()
			self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 50,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
	ApplyDamage( self.damageTable )
end

function modifier_meepo_earthbind_lua:OnDestroy()
end

function modifier_meepo_earthbind_lua:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function modifier_meepo_earthbind_lua:GetEffectName()
	return "particles/units/heroes/hero_meepo/meepo_earthbind.vpcf"
end

function modifier_meepo_earthbind_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end