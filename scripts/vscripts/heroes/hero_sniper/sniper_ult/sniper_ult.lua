LinkLuaModifier("modifier_sniper_ult", "heroes/hero_sniper/sniper_ult/sniper_ult.lua", LUA_MODIFIER_MOTION_NONE)

sniper_ult = class({})

function sniper_ult:GetAbilityTextureName()
	return "sniper_assassinate"
end

function sniper_ult:OnSpellStart()
	if IsServer() then
		local duration = self:GetSpecialValueFor("duration")
		self:GetCaster():EmitSound("Hero_TrollWarlord.BattleTrance.Cast")	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sniper_ult", {duration = duration})
		
		
		local cast_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( cast_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetCaster():GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(cast_pfx)
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)
	end
end

-------------------------------------------
modifier_sniper_ult = modifier_sniper_ult or class({})
function modifier_sniper_ult:IsHidden() return false end
function modifier_sniper_ult:IsPurgable() return false end
function modifier_sniper_ult:IsPurgeException() return false end
function modifier_sniper_ult:IsStunDebuff() return false end
function modifier_sniper_ult:RemoveOnDeath() return true end
-------------------------------------------

function modifier_sniper_ult:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_sniper_ult:OnCreated()
	local ability = self:GetAbility()
	local parent = self:GetParent()
	self.base_attack_time = ability:GetSpecialValueFor("base_attack_time")
	self.less = ability:GetSpecialValueFor("less")
	self.bonus_range = ability:GetSpecialValueFor("bonus_range")
	self.bonus_attack_damage = ability:GetSpecialValueFor("bonus_attack_damage")
	self:StartIntervalThink(0.1)

end

function modifier_sniper_ult:OnIntervalThink()
	if IsServer() then
		self:GetParent():SetHealth(math.max( self:GetParent():GetHealth() - (self:GetParent():GetHealth()/100*self.less), 1))
	end
end

function modifier_sniper_ult:OnRefresh()
	self:OnCreated()
end

function modifier_sniper_ult:GetModifierBaseAttackTimeConstant()
	return self.base_attack_time
end

function modifier_sniper_ult:GetModifierMoveSpeedBonus_Constant()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_sniper_agi1")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_sniper_agi1"):GetLevel() > 0 then 
			return 550
		end
	end
	return -500
end

function modifier_sniper_ult:GetModifierAttackRangeBonus()
	return self.bonus_range
end

function modifier_sniper_ult:GetModifierDamageOutgoing_Percentage()
	return self.bonus_attack_damage
end

function modifier_sniper_ult:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end

function modifier_sniper_ult:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end