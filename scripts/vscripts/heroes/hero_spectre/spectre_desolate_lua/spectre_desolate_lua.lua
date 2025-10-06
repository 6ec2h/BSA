spectre_desolate_lua = class({})
LinkLuaModifier( "modifier_spectre_desolate_lua", "heroes/hero_spectre/spectre_desolate_lua/spectre_desolate_lua", LUA_MODIFIER_MOTION_NONE )

function spectre_desolate_lua:GetIntrinsicModifierName()
	return "modifier_spectre_desolate_lua"
end

--------------------------------------------------------------

modifier_spectre_desolate_lua = class({})

function modifier_spectre_desolate_lua:IsHidden()
	return true
end

function modifier_spectre_desolate_lua:IsPurgable()
	return false
end

function modifier_spectre_desolate_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_spectre_desolate_lua:OnAttackLanded( params )
	if IsServer() and (not self:GetParent():PassivesDisabled()) and params.attacker == self:GetParent() and self:GetParent():GetTeamNumber() ~= params.target:GetTeamNumber() then
		local talent = self:GetCaster():FindAbilityByName("special_bonus_spectre_tal2")
		if talent ~= nil and talent:GetLevel() > 0 then
			self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) + 5
		else
			self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
		end

		local damageTable = {
			victim = params.target,
			attacker = self:GetParent(),
			damage = self:GetParent():GetAttackDamage()/100*self.damage,
			damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}
		ApplyDamage(damageTable)
		EmitSoundOn("Hero_Spectre.Desolate", self:GetParent())

    	local particle_name = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
    	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_POINT, params.target)
        ParticleManager:SetParticleControl(particle, 0, Vector( params.target:GetAbsOrigin().x, params.target:GetAbsOrigin().y, GetGroundPosition(params.target:GetAbsOrigin(), params.target).z + 140))                                                
        ParticleManager:SetParticleControlForward(particle, 0, self:GetParent():GetForwardVector())
	end
end