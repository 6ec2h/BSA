legion_courage = class({})
LinkLuaModifier( "modifier_legion_courage", "heroes/hero_legion/legion_courage/legion_courage", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function legion_courage:GetIntrinsicModifierName()
	return "modifier_legion_courage"
end

-------------------------------------------------------------------------------------------------------------

modifier_legion_courage = class({})


function modifier_legion_courage:IsHidden()
	return true
end

function modifier_legion_courage:IsPurgable()
	return false
end

function modifier_legion_courage:OnCreated( kv )
end

function modifier_legion_courage:OnRefresh( kv )
end

function modifier_legion_courage:OnDestroy( kv )

end


function modifier_legion_courage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_legion_courage:OnAttackLanded( params )
	if not IsServer() then return end
	
	if self:GetAbility():IsFullyCastable() then

	self.chance = self:GetAbility():GetSpecialValueFor( "trigger_chance" )

	if self:GetCaster():FindAbilityByName("special_bonus_legion_commander_agi11")~=nil then
		if self:GetCaster():FindAbilityByName("special_bonus_legion_commander_agi11"):GetLevel() > 0 then
			self.chance = 75 
		end
	end
		
	if self:GetAbility() and not self:GetCaster():PassivesDisabled() and ((params.target == self:GetParent() and not params.attacker:IsBuilding() and not params.attacker:IsOther() and params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber())) then
			damage_type = DAMAGE_TYPE_PHYSICAL
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					
			if RandomInt(1,100) <= self.chance then 
				if params.target == self:GetParent() and params.attacker ~= params.target:GetTeamNumber() then
					if (params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() < 300 then
						damage = self:GetParent():GetAverageTrueAttackDamage(nil)
						local heal = damage * self:GetAbility():GetSpecialValueFor("damage")/100
						self:GetParent():Heal( heal, self:GetAbility() )
						SendOverheadEventMessage( self:GetParent():GetPlayerOwner(), OVERHEAD_ALERT_HEAL , self:GetParent(), heal, nil )
					
						ApplyDamage({victim = params.attacker, attacker = self:GetParent(), damage = damage, damage_type = damage_type, damage_flags = damage_flags})
						self:GetAbility():UseResources( false,false, false, true )
						self:PlayEffects()
					end	
				end
			end
		end
	end
end

--------------------------------------------------------------------------------

function modifier_legion_courage:PlayEffects2( target )
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


function modifier_legion_courage:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_legion_commander/legion_commander_courage_tgt_flash.vpcf"----"particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf"--"particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
	
	StartAnimation(self:GetParent(), {duration = 0.1, activity = ACT_DOTA_CAST3_STATUE})--ACT_DOTA_MOMENT_OF_COURAGE
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast2 )
	
	EmitSoundOn( "Hero_LegionCommander.Courage", self:GetParent() )
end