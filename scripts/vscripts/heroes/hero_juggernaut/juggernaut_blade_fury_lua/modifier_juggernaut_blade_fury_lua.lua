modifier_juggernaut_blade_fury_lua = class({})

function modifier_juggernaut_blade_fury_lua:IsHidden()
	return false
end

function modifier_juggernaut_blade_fury_lua:IsDebuff()
	return false
end

function modifier_juggernaut_blade_fury_lua:IsPurgable()
	return false
end

function modifier_juggernaut_blade_fury_lua:DestroyOnExpire()
	return false
end

function modifier_juggernaut_blade_fury_lua:OnCreated( kv )
	self.tick = self:GetAbility():GetSpecialValueFor( "blade_fury_damage_tick" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "blade_fury_radius" ) -- special value
	self.dps = self:GetAbility():GetSpecialValueFor( "blade_fury_damage" ) -- special value
	
	self.max_count = kv.duration/self.tick
	self.count = 0

	if IsServer() then
	
		if self:GetParent():HasAbility("juggernaut_omni_slash_lua") then
			self:GetParent():FindAbilityByName("juggernaut_omni_slash_lua"):SetActivated(false)
		end
	
		self.damageTable = {
			attacker = self:GetParent(),
			damage = self.dps * self.tick,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		self:StartIntervalThink( self.tick )
	end
	


	self:PlayEffects()
end

function modifier_juggernaut_blade_fury_lua:OnRefresh( kv )
	self.tick = self:GetAbility():GetSpecialValueFor( "blade_fury_damage_tick" ) -- special value
	self.radius = self:GetAbility():GetSpecialValueFor( "blade_fury_radius" ) -- special value
	self.dps = self:GetAbility():GetSpecialValueFor( "blade_fury_damage" ) -- special value
	self.count = 0

	if IsServer() then
		self.damageTable.damage = self.dps * self.tick
	end
end

function modifier_juggernaut_blade_fury_lua:OnDestroy( kv )
	if IsServer() then
		if self:GetParent():HasAbility("juggernaut_omni_slash_lua") then
			self:GetParent():FindAbilityByName("juggernaut_omni_slash_lua"):SetActivated(true)
		end
	end

	local sound_cast = "Hero_Juggernaut.BladeFuryStart"
	StopSoundOn( sound_cast, self:GetParent() )
end

function modifier_juggernaut_blade_fury_lua:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}

	return state
end

function modifier_juggernaut_blade_fury_lua:OnIntervalThink()
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		self:PlayEffects2( enemy )
	end
	self.count = self.count+1
	if self.count>= self.max_count then
		self:Destroy()
	end
end

function modifier_juggernaut_blade_fury_lua:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius, 0, 0 ) )

	self:AddParticle(effect_cast, false, false, -1, false, false)
	EmitSoundOn( "Hero_Juggernaut.BladeFuryStart", self:GetParent() )
end

function modifier_juggernaut_blade_fury_lua:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
