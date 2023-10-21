function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	TargetAbility = thisEntity:FindAbilityByName( "boss_nyx_assassin_mana_burn" )
	PointAbility = thisEntity:FindAbilityByName( "boss_nyx_assassin_impale" )
	NoTargetAbility = thisEntity:FindAbilityByName( "frostivus2018_spectre_active_dispersion" )

	thisEntity:SetContextThink( "NyxThink", NyxThink, 1 )
end

--------------------------------------------------------------------------------

function NyxThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end

	if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
		thisEntity.bInitialized = true
	end

	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 1750 )
		thisEntity.bAcqRangeModified = true
	end

	if thisEntity:GetAggroTarget() then
		thisEntity.fTimeWeLostAggro = nil
	end

	if thisEntity:GetAggroTarget() and ( thisEntity.fTimeAggroStarted == nil ) then
		thisEntity.fTimeAggroStarted = GameRules:GetGameTime()
	end

	if ( not thisEntity:GetAggroTarget() ) and ( thisEntity.fTimeAggroStarted ~= nil ) then
		thisEntity.fTimeWeLostAggro = GameRules:GetGameTime()
		thisEntity.fTimeAggroStarted = nil
	end

	if ( not thisEntity:GetAggroTarget() ) then
		if thisEntity.fTimeWeLostAggro and ( GameRules:GetGameTime() > ( thisEntity.fTimeWeLostAggro + 1.0 ) ) then
			return RetreatHome()
		end
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
			if TargetAbility ~= nil and TargetAbility:IsCooldownReady() then
				TargetAbilityCast(enemies[ RandomInt( 1, #enemies ) ])
				return RandomInt(1,3)
			end
			
			if PointAbility ~= nil and PointAbility:IsCooldownReady() then
				PointAbilityCast(enemies[ RandomInt( 1, #enemies ) ])
				return RandomInt(1,3)
			end
			
			if NoTargetAbility ~= nil and NoTargetAbility:IsCooldownReady() then
				NoTargetAbilityCast(enemies[ RandomInt( 1, #enemies ) ])
				return RandomInt(1,3)
			end
		end	
	return 0.5
end

--------------------------------------------------------------------------------

function TargetAbilityCast(unit)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = TargetAbility:entindex(), -- индекс способности
        TargetIndex = unit:entindex(),
        Queue = false,
    })
    return 1.5
end

function NoTargetAbilityCast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function PointAbilityCast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 1.5
end

--------------------------------------------------------------------------------

function RetreatHome()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity.vInitialSpawnPos,
	})
	return 0.5
end