custom_stun = class({})

function custom_stun:OnSpellStart()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do 
		EmitSoundOn( "Hero_Sven.StormBoltImpact", enemy )
		enemy:AddNewModifier( self:GetCaster(), nil, "modifier_stunned", {duration = 3})
	end	
end