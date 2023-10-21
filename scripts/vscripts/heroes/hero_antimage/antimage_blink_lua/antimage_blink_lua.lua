LinkLuaModifier( "modifier_after_illusion", "heroes/hero_antimage/antimage_blink_lua/antimage_blink_lua", LUA_MODIFIER_MOTION_NONE )

antimage_blink_lua = class({})

function antimage_blink_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")	
	count = 1
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_antimage_int2")
	if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		count = 2
	end
	
	for i=1, count do
		local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), 
		{
			duration = duration,
		}
		, 1, self:GetCaster():GetHullRadius(), true, true)
		for _, illusion in pairs(illusions) do
			illusion:SetAbsOrigin(target:GetOrigin() + RandomVector(RandomInt(50, 150)))
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_after_illusion", {})
		end
	end
end

---------------------------------------------------------

modifier_after_illusion = class({})

function modifier_after_illusion:IsHidden()		return true end
function modifier_after_illusion:IsPurgable()	return false end

function modifier_after_illusion:CheckState()
	local state = {
		[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end



