shaman_wards_custom = class({})

function shaman_wards_custom:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end



function shaman_wards_custom:GetAOERadius()
	return 150
end

function shaman_wards_custom:OnSpellStart()
	local caster = self:GetCaster()
	local position = self:GetCursorPosition()
	local count = self:GetSpecialValueFor("count")
	local sound_cast = "Hero_ShadowShaman.SerpentWard"
	EmitSoundOn( sound_cast, caster )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_shadow_shaman_int10")             
	if abil ~= nil and abil:GetLevel() > 0 then 
	count = count + 3
	end

	for i = 1, count do	  

	shadow_ward = CreateUnitByName("shadow_shaman_ward", position + RandomVector( RandomFloat( 50, 50 )), true, caster, nil, caster:GetTeam())
	FindClearSpaceForUnit(shadow_ward, position, false)
	shadow_ward:SetControllableByPlayer(caster:GetPlayerID(), true)
	shadow_ward:SetOwner(caster)
	shadow_ward:AddAbility("summon_buff"):SetLevel(1)
	shadow_ward:AddNewModifier( shadow_ward, nil, "modifier_kill", {duration = self:GetSpecialValueFor("duration")} )
	shadow_ward:AddNewModifier( shadow_ward, nil, "modifier_shadow_ward_hp", {} )
	end
end

LinkLuaModifier("modifier_shadow_ward_hp", "heroes/hero_shaman/shaman_wards/shaman_wards", LUA_MODIFIER_MOTION_NONE)

----------------------------------------------
modifier_shadow_ward_hp = class({})

function modifier_shadow_ward_hp:IsDebuff() return false end
function modifier_shadow_ward_hp:IsHidden() return true end
function modifier_shadow_ward_hp:IsPurgable() return false end

function modifier_shadow_ward_hp:OnCreated()
end

function modifier_shadow_ward_hp:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_DISABLE_HEALING
	}
end

function modifier_shadow_ward_hp:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_shadow_ward_hp:GetModifierIncomingDamage_Percentage()
	return -100
end

function modifier_shadow_ward_hp:GetDisableHealing()
    return 1
end

function modifier_shadow_ward_hp:OnAttackLanded(params)
	if IsServer() then
		if params.target == self:GetParent() then
			local damage = 1
			if self:GetParent():GetHealth() > damage then
				self:GetParent():SetHealth( self:GetParent():GetHealth() - damage)
			else
				self:GetParent():Kill(nil, params.attacker)
			end
		end
	end
end
