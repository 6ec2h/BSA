function last_chance(keys)
	local wws= keys.caster
	local new_charges = keys.ability:GetCurrentCharges() - 1
	
	local hRelay = Entities:FindByName( nil, "tp_off" )
	if hRelay == nil then return end
	hRelay:Trigger(nil,nil)
	
	if new_charges <= 0 then
		keys.caster:RemoveItem(keys.ability)
		   for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
			if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
				if PlayerResource:HasSelectedHero( nPlayerID ) then
					local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
					if not hero:IsAlive() then

					local point = wws:GetAbsOrigin()
						hero:RespawnHero(false, false)
						FindClearSpaceForUnit(hero, point, false)
						hero:Stop()
					end
					hero:SetHealth( hero:GetMaxHealth() )
					hero:SetMana( hero:GetMaxMana() )
					hero:EmitSound("Hero_Omniknight.GuardianAngel.cast")
					hero:AddNewModifier( hero, nil, "modifier_omninight_guardian_angel", { duration = 2.5 } )
				end
			end
		end
	else 
		keys.ability:SetCurrentCharges(new_charges)
	end
end

