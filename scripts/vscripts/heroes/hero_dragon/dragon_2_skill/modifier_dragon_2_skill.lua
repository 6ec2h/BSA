LinkLuaModifier( "modifier_dragon_2_skill", "heroes/hero_dragon/dragon_2_skill/modifier_dragon_2_skill", LUA_MODIFIER_MOTION_NONE )

modifier_dragon = class({})

function modifier_dragon:IsHidden()
	return true
end

function modifier_dragon:IsPurgable()
	return false
end

function modifier_dragon:OnCreated( kv )
self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_dragon:OnRefresh( kv )
self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
end

function modifier_dragon:OnDestroy( kv )

end

function modifier_dragon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}
	return funcs
end

function modifier_dragon:GetModifierProcAttack_Feedback( params )
	if IsServer() then
			params.target:AddNewModifier(
				self:GetParent(),
				self:GetAbility(),
				"modifier_dragon_2_skill",
				{ duration = self.duration }
			)
	end
end


-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------

modifier_dragon_2_skill = class({})

function modifier_dragon_2_skill:IsHidden()
	return false
end

function modifier_dragon_2_skill:IsDebuff()
	return true
end

function modifier_dragon_2_skill:IsStunDebuff()
	return false
end

function modifier_dragon_2_skill:IsPurgable()
	return false
end


function modifier_dragon_2_skill:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.mag_resist = self:GetAbility():GetSpecialValueFor( "mag_resist" )
	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_dragon_2_skill:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.mag_resist = self:GetAbility():GetSpecialValueFor( "mag_resist" )
	if not IsServer() then return end
	
	self.damageTable.damage = damage	
end

function modifier_dragon_2_skill:OnRemoved()
end

function modifier_dragon_2_skill:OnDestroy()
end

--------------------------------------------------------------------------------
function modifier_dragon_2_skill:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_dragon_2_skill:GetModifierMagicalResistanceBonus()	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int10")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int10"):GetLevel() > 0 then 
			return self.mag_resist * 2
		end
	end
	return self.mag_resist
end

function modifier_dragon_2_skill:GetModifierPhysicalArmorBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi8")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi8"):GetLevel() > 0 then 
			return self.mag_resist/2
		end
	end
	return 0
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_dragon_2_skill:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_dragon_2_skill:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_dragon_2_skill:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end