LinkLuaModifier("modifier_spike_trap_lua", "traps/zone_trap/spike_trap", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spike_trap_thinker_lua", "traps/zone_trap/spike_trap", LUA_MODIFIER_MOTION_NONE)

spike_trap = class({})

function spike_trap:GetAOERadius()
	return self:GetSpecialValueFor( "light_strike_array_aoe" )
end

function spike_trap:OnSpellStart()
	self.light_strike_array_aoe = self:GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_delay_time = self:GetSpecialValueFor( "light_strike_array_delay_time" )

	local kv = {}
	CreateModifierThinker( self:GetCaster(), self, "modifier_spike_trap_thinker_lua", kv, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )
end

--------------------------------------------------------------------------------

modifier_spike_trap_lua = class({})

function modifier_spike_trap_lua:IsDebuff()
	return true
end

function modifier_spike_trap_lua:IsHidden()
	return true
end

function modifier_spike_trap_lua:IsStunDebuff()
	return true
end

function modifier_spike_trap_lua:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_spike_trap_lua:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_spike_trap_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_spike_trap_lua:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_spike_trap_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

--------------------------------------------------------------------------------

modifier_spike_trap_thinker_lua = class({})

function modifier_spike_trap_thinker_lua:IsHidden()
	return true
end

function modifier_spike_trap_thinker_lua:OnCreated( kv )
	self.light_strike_array_aoe = self:GetAbility():GetSpecialValueFor( "light_strike_array_aoe" )
	self.light_strike_array_damage = self:GetAbility():GetSpecialValueFor( "light_strike_array_damage" )
	self.light_strike_array_stun_duration = self:GetAbility():GetSpecialValueFor( "light_strike_array_stun_duration" )
	self.light_strike_array_delay_time = self:GetAbility():GetSpecialValueFor( "light_strike_array_delay_time" )
	if IsServer() then
		self:StartIntervalThink( self.light_strike_array_delay_time )
		EmitSoundOnLocationForAllies( self:GetParent():GetOrigin(), "Ability.PreLightStrikeArray", self:GetCaster() )
	end
end

function modifier_spike_trap_thinker_lua:OnIntervalThink()
	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.light_strike_array_aoe, false )
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.light_strike_array_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		if #enemies > 0 then
			for _,enemy in pairs(enemies) do
				if enemy ~= nil and ( not enemy:IsMagicImmune() ) and ( not enemy:IsInvulnerable() ) then

					local damage = {
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.light_strike_array_damage,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility()
					}

					ApplyDamage( damage )
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_spike_trap_lua", { duration = self.light_strike_array_stun_duration } )
				end
			end
		end
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Conquest.SpikeTrap.Activate.Generic", self:GetCaster() )
		UTIL_Remove( self:GetParent() )
	end
end