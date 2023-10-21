tinker_summon = class({})
LinkLuaModifier( "modifier_tinker_bot", "heroes/hero_tinker/tinker_summon/tinker_summon.lua", LUA_MODIFIER_MOTION_NONE )

function tinker_summon:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Tinker.March_of_the_Machines.Cast")	
	local count = self:GetSpecialValueFor("count")
	local duration = self:GetSpecialValueFor("duration")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_tinker_int3")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_tinker_int3"):GetLevel() > 0  then
			count = 4
		end
	end
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_tinker_int4")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_tinker_int4"):GetLevel() > 0  then
			duration = 15
		end
	end
	
	for i = 1, count do
	local bot = CreateUnitByName( "tinkerbot", self:GetCaster():GetAbsOrigin() + RandomVector( RandomFloat( 150, 150 )), true, nil, nil, DOTA_TEAM_GOODGUYS )	
	bot:AddNewModifier(self:GetCaster(), self, "modifier_tinker_bot",  { }) 	
	bot:AddNewModifier(self:GetCaster(), self, "modifier_kill",  {duration = duration})
	bot:SetOwner(self:GetCaster())
	bot:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
		local owner_ability = self:GetCaster():FindAbilityByName("tinker_heat_seeking_missile_lua")
			if owner_ability ~= nil and owner_ability:GetLevel() > 0 then
				bot:FindAbilityByName("tinker_heat_seeking_missile_lua"):SetLevel(owner_ability:GetLevel())
			else
				bot:RemoveAbility("tinker_heat_seeking_missile_lua")
			end
		end

end

modifier_tinker_bot = class({})

function modifier_tinker_bot:IsHidden()
	return false
end

function modifier_tinker_bot:IsPurgable()
    return false
end

function modifier_tinker_bot:OnCreated( kv )
	if IsServer() then
		if self:GetParent():GetUnitName() == "tinkerbot" then
			self:GetParent():SetRenderColor( 255, 233, 0 )		
		end
	end
end

function modifier_tinker_bot:CheckState()
	local state = {
		--[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return state
end

function modifier_tinker_bot:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	}
	return funcs
end

function modifier_tinker_bot:GetAbsoluteNoDamageMagical( params )
	return 1
end

function modifier_tinker_bot:GetAbsoluteNoDamagePure( params )
	return 1
end

function modifier_tinker_bot:GetAbsoluteNoDamagePhysical( params )
	return 1
end