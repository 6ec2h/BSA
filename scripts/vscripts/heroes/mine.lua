custom_mine = class({})

function custom_mine:OnSpellStart()
	if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do 
		local point = enemy:GetAbsOrigin()
		enemy:EmitSound("Hero_Techies.RemoteMine.Plant")
		local dummy = CreateUnitByName("land_mine_ultra", point + RandomVector( RandomInt( 0, 150 )), false, nil, nil, self:GetCaster():GetTeamNumber())
	end	
end