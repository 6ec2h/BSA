LinkLuaModifier( "modifier_treant_seed", "abilities/creeps/treant_seed", LUA_MODIFIER_MOTION_NONE )

treant_seed = class({})

function treant_seed:OnSpellStart()
	self.hTarget = self:GetCursorTarget()
	self.hTarget:AddNewModifier(self:GetCaster(), self, "modifier_treant_seed", {duration = self:GetSpecialValueFor("duration") - FrameTime()})
	self.hTarget:AddNewModifier(self:GetCaster(), self, "modifier_silence", {duration = self:GetSpecialValueFor("duration") - FrameTime()})
end

---------------------------------------------------

modifier_treant_seed = class({})

function modifier_treant_seed:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage_interval	= self:GetAbility():GetSpecialValueFor("tick")
	self.leech_damage		= self:GetAbility():GetSpecialValueFor("damage")
	self.remnants_radius	= 400
	self.projectile_speed	= 400
	
	if not IsServer() then return end
	
	self.damage_type = DAMAGE_TYPE_MAGICAL
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.damage_interval)
end

function modifier_treant_seed:OnIntervalThink()
	self:GetParent():EmitSound("Hero_Treant.LeechSeed.Tick")

	self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed_damage_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(self.damage_particle)
	self.damage_particle = nil
	
	self.damage = self.leech_damage
	
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
	
	for _, unit in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.remnants_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		ProjectileManager:CreateTrackingProjectile({
			EffectName			= "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
			Ability				= self:GetAbility(),
			Source				= unit,
			vSourceLoc			= unit:GetAbsOrigin(),
			Target				= self:GetCaster(),
			iMoveSpeed			= self.projectile_speed,
			flExpireTime		= nil,
			bDodgeable			= false,
			bIsAttack			= false,
			bReplaceExisting	= false,
			iSourceAttachment	= nil,
			bDrawsOnMinimap		= nil,
			bVisibleToEnemies	= true,
			bProvidesVision		= false,
			iVisionRadius		= nil,
			iVisionTeamNumber	= nil,
			ExtraData			= {damage = self.damage}
		})
	end
end

function treant_seed:OnProjectileHit_ExtraData(target, location, ExtraData)
	target:Heal(ExtraData.damage, self:GetCaster())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, ExtraData.damage, nil)
end