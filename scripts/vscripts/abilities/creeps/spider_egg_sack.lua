LinkLuaModifier( "modifier_spider_egg_sack", "abilities/creeps/spider_egg_sack", LUA_MODIFIER_MOTION_NONE )

spider_egg_sack = class({})

function spider_egg_sack:GetIntrinsicModifierName()
	return "modifier_spider_egg_sack"
end

-------------------------------------------------------------------------

modifier_spider_egg_sack = class({})

function modifier_spider_egg_sack:IsHidden()
	return true
end

function modifier_spider_egg_sack:CheckState()
	local state =
	{
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = false,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
	return state
end

function modifier_spider_egg_sack:OnCreated( kv )
	if IsServer() then
		self.spider_min = self:GetAbility():GetSpecialValueFor( "spider_min" )
		self.spider_max = self:GetAbility():GetSpecialValueFor( "spider_max" )
		self.trigger_radius = self:GetAbility():GetSpecialValueFor( "trigger_radius" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self:StartIntervalThink( 0.25 )
	end
end

function modifier_spider_egg_sack:OnIntervalThink()
	if IsServer() then
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.trigger_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #enemies > 0 then
			self:Burst()
			self:StartIntervalThink(-1)
		end
	end
end

function modifier_spider_egg_sack:Burst()
	if IsServer() then
		for i=0,RandomInt( self.spider_min, self.spider_max ) do
			local hUnit = CreateUnitByName( "npc_dota_creature_spider_small", self:GetParent():GetOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS )
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius / 2, 0.4, self.radius ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs ( enemies ) do
			if enemy ~= nil then
				ApplyDamage({
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.damage,
					damage_type = DAMAGE_TYPE_PURE,
				})
			end
		end
		
		EmitSoundOn( "Hero_Broodmother.SpawnSpiderlings", self:GetParent())
		EmitSoundOn( "EggSack.Burst", self:GetParent() )
		self:GetParent():AddNoDraw()
		self:GetParent():ForceKill(false)
	end
end

