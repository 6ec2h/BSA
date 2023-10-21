modifier_sound_attack = class({})

function modifier_sound_attack:IsHidden()
	return true
end

function modifier_sound_attack:IsPurgable()
    return false
end

function modifier_sound_attack:RemoveOnDeath()
    return false
end

function modifier_sound_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
	return funcs
end

function modifier_sound_attack:OnAttackLanded( params )
	if IsServer() then
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end

		if pass then
			EmitSoundOn( "Hero_EarthShaker.Attack", self:GetParent() )
		end
	end
end
