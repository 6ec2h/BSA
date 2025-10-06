function Spawn( entityKeyValues )
	if not IsServer() then
        return
    end
    if thisEntity == nil then
        return
    end
    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.5 ) 
end

function NecroLordThink()
	if thisEntity:GetRenderColor() then
		thisEntity:SetRenderColor( 104, 85, 70 )
	end
	if ( not thisEntity:IsAlive() ) then 
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then 
        return 1  
    end

    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
    if #enemies > 0 and thisEntity:GetDayTimeVisionRange() < 1000 then
	    thisEntity:SetDayTimeVisionRange(1500)
		thisEntity:SetNightTimeVisionRange(1500)
		quest_system:quest_23()
		local particleLeader = ParticleManager:CreateParticle( "particles/dire_fx/fire_barracks.vpcf", PATTACH_OVERHEAD_FOLLOW, thisEntity ) 
		ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, thisEntity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", thisEntity:GetAbsOrigin(), true )
		thisEntity:Attribute_SetIntValue("particleID", particleLeader)
		end
	return 0.01
end