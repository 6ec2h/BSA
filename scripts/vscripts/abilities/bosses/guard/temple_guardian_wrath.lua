temple_guardian_wrath = class({})
LinkLuaModifier( "modifier_temple_guardian_wrath_thinker", "abilities/bosses/guard/temple_guardian_wrath", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_temple_guardian_immunity", "abilities/bosses/guard/temple_guardian_wrath", LUA_MODIFIER_MOTION_NONE )

function temple_guardian_wrath:GetChannelAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_4
end

function temple_guardian_wrath:OnAbilityPhaseStart()
	if IsServer() then
		self.channel_duration = self:GetSpecialValueFor( "channel_duration" )
		local fImmuneDuration = self.channel_duration + self:GetCastPoint()
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_temple_guardian_immunity", { duration = fImmuneDuration } )

		self.nPreviewFX = ParticleManager:CreateParticle( "particles/darkmoon_creep_warning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( self.nPreviewFX, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nPreviewFX, 1, Vector( 250, 250, 250 ) )
		ParticleManager:SetParticleControl( self.nPreviewFX, 15, Vector( 176, 224, 230 ) )
	end

	return true
end

function temple_guardian_wrath:OnAbilityPhaseInterrupted()
	if IsServer() then
		ParticleManager:DestroyParticle( self.nPreviewFX, false )
	end 
end

function temple_guardian_wrath:OnSpellStart()
	if IsServer() then	
		ParticleManager:DestroyParticle( self.nPreviewFX, false )

		self.effect_radius = self:GetSpecialValueFor( "effect_radius" )
		self.interval = self:GetSpecialValueFor( "interval" )

		self.flNextCast = 0.0

		EmitSoundOn( "TempleGuardian.Wrath.Cast", self:GetCaster() )
		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_omninight_guardian_angel", {} )

		--local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
		--ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.effect_radius, self.channel_duration, 0.0 ) )
		--ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

function temple_guardian_wrath:OnChannelThink( flInterval )
	if IsServer() then
		self.flNextCast = self.flNextCast + flInterval
		if self.flNextCast >= self.interval  then

			-- Try not to overlap wrath_thinker locations, but use the last position attempted if we spend too long in the loop
			local nMaxAttempts = 7
			local nAttempts = 0
			local vPos = nil

			repeat
				vPos = self:GetCaster():GetOrigin() + RandomVector( RandomInt( 50, self.effect_radius ) )
				local hThinkersNearby = Entities:FindAllByClassnameWithin( "npc_dota_thinker", vPos, 600 )
				local hOverlappingWrathThinkers = {}

				for _, hThinker in pairs( hThinkersNearby ) do
					if ( hThinker:HasModifier( "modifier_temple_guardian_wrath_thinker" ) ) then
						table.insert( hOverlappingWrathThinkers, hThinker )
					end
				end
				nAttempts = nAttempts + 1
				if nAttempts >= nMaxAttempts then
					break
				end
			until ( #hOverlappingWrathThinkers == 0 )

			CreateModifierThinker( self:GetCaster(), self, "modifier_temple_guardian_wrath_thinker", {}, vPos, self:GetCaster():GetTeamNumber(), false )
			self.flNextCast = self.flNextCast - self.interval
		end
		
	end
end

function temple_guardian_wrath:OnChannelFinish( bInterrupted )
	if IsServer() then
		self:GetCaster():RemoveModifierByName( "modifier_omninight_guardian_angel" )
	end
end

-----------------------------------------------------------------------------

modifier_temple_guardian_immunity = class({})

function modifier_temple_guardian_immunity:IsHidden()
	return true
end

function modifier_temple_guardian_immunity:IsPurgable()
	return false
end

function modifier_temple_guardian_immunity:CheckState()
	local state = {}
	if IsServer()  then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
		state[MODIFIER_STATE_INVULNERABLE] = true
		state[MODIFIER_STATE_OUT_OF_GAME] = true
	end
	
	return state
end

function modifier_temple_guardian_immunity:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end

---------------------------------------------------------------------------------

modifier_temple_guardian_wrath_thinker = class({})

function modifier_temple_guardian_wrath_thinker:OnCreated( kv )
	if IsServer() then
		self.delay = self:GetAbility():GetSpecialValueFor( "delay" )
		self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
		self.blast_damage = self:GetAbility():GetSpecialValueFor( "blast_damage" )

		self:StartIntervalThink( self.delay )

		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast_pre.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius, self.delay, 1.0 ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )
	end
end

function modifier_temple_guardian_wrath_thinker:OnIntervalThink()
	if IsServer() then
		local nFXIndex = ParticleManager:CreateParticle( "particles/test_particle/dungeon_generic_blast.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector ( self.radius, self.radius, self.radius ) )
		ParticleManager:SetParticleControl( nFXIndex, 15, Vector( 175, 238, 238 ) )
		ParticleManager:SetParticleControl( nFXIndex, 16, Vector( 1, 0, 0 ) )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "TempleGuardian.Wrath.Explosion", self:GetParent() )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
		for _,enemy in pairs( enemies ) do
			if enemy ~= nil and enemy:IsInvulnerable() == false then
				local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.blast_damage,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )
			end
		end

		UTIL_Remove( self:GetParent() )
	end
end