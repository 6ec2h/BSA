_G.Units = {}
require('essentials')

LinkLuaModifier( "modifier_item_stonework_pendant", "heroes/hero_new/modifier_item_stonework_pendant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sound_attack", "modifiers/modifier_sound_attack", LUA_MODIFIER_MOTION_NONE )

function trigger(trigger)
    trigger.activator:SetOrigin(Vector(6000,7000,100))
end

function prt(t)
	GameRules:SendCustomMessage(''..t,0,0)
end

_G.Open_xdes = 0

function xdes_open()
	print(_G.Open_xdes, "_G.Open_xdes")
	_G.Open_xdes = _G.Open_xdes + 1
	if _G.Open_xdes == 2 then
		local hRelay = Entities:FindByName( nil, "xdes_move_logic" )
		hRelay:Trigger(nil,nil)		
	end	
end

function Swap(trigger)
	local caster = trigger.activator
	local level = caster:GetLevel()
	if caster ~= nil and level == 1 then
		local Key = caster:FindItemInInventory( "item_dado_stone" )
			if Key ~= nil and not Key:IsMuted() then
				caster:RemoveItem(Key)
						
				local hRelay = Entities:FindByName( nil, "dado_log" )
				hRelay:Trigger(nil,nil)		
						
				local playerID = caster:GetPlayerID()
				local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
				local newHeroName = "npc_dota_hero_dado"	
				local gold = oldHero:GetGold()
				local experience = oldHero:GetCurrentXP() 
				print("gold = "..gold.." exp = "..experience)	
					if playerID ~= nil and playerID ~= -1 then 
						caster:ForceKill(false)
						items_table = {} 
						for i = 0, 23 do 
							local item = oldHero:GetItemInSlot( i ) 
							if item ~= nil then 
								items_table[item:GetName()] = item:GetCurrentCharges() 
								item:RemoveSelf() 
							end 
						end 
						local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
						newHero:SetGold(gold, false)
						newHero:AddAbility("Dado_passivka"):SetLevel(1)
						newHero:AddExperience(experience, 0, false, true)
						for item,stacks in pairs(items_table) do 
							newHero:AddItemByName(item):SetCurrentCharges(stacks) 
						local Key = newHero:FindItemInInventory( "item_dado_stone" )
						if Key ~= nil then
						newHero:RemoveItem(Key)
						end 
					end 
				end
			UTIL_Remove(caster)
			essentials:Init()
		end
	end
end

function swap2(trigger)
	local caster = trigger.activator
	local level = caster:GetLevel()
	if caster ~= nil and level == 1 then
		local Key = caster:FindItemInInventory( "item_triss_stone" )
			if Key ~= nil and not Key:IsMuted() then
				caster:RemoveItem(Key)
						
				local hRelay = Entities:FindByName( nil, "tris_log" )
				hRelay:Trigger(nil,nil)		
						
				local playerID = caster:GetPlayerID()
				local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
				local newHeroName = "npc_dota_hero_triss"	
				local gold = oldHero:GetGold()
				local experience = oldHero:GetCurrentXP() 
				print("gold = "..gold.." exp = "..experience)	
					if playerID ~= nil and playerID ~= -1 then 
						caster:ForceKill(false)
						items_table = {} 
						for i = 0, 23 do 
							local item = oldHero:GetItemInSlot( i ) 
							if item ~= nil then 
								items_table[item:GetName()] = item:GetCurrentCharges() 
								item:RemoveSelf() 
							end 
						end 
						local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
						newHero:SetGold(gold, false)
						newHero:AddAbility("ability_splash"):SetLevel(1)		
						newHero:AddExperience(experience, 0, false, true)
						for item,stacks in pairs(items_table) do 
							newHero:AddItemByName(item):SetCurrentCharges(stacks) 
						local Key = newHero:FindItemInInventory( "item_triss_stone" )
						if Key ~= nil then
						newHero:RemoveItem(Key)
						end 
					end 
				end
			UTIL_Remove(caster)
			essentials:Init()
		end
	end
end

function swap3(trigger)
	local caster = trigger.activator
	local level = caster:GetLevel()
	if caster ~= nil and level == 1 then
		local Key = caster:FindItemInInventory( "item_destroyer_stone" )
			if Key ~= nil and not Key:IsMuted() then
				caster:RemoveItem(Key)
						
				local hRelay = Entities:FindByName( nil, "destroyer_log" )
				hRelay:Trigger(nil,nil)		
						
				local playerID = caster:GetPlayerID()
				local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
				local newHeroName = "npc_dota_hero_destroyer"	
				local gold = oldHero:GetGold()
				local experience = oldHero:GetCurrentXP() 
				print("gold = "..gold.." exp = "..experience)	
					if playerID ~= nil and playerID ~= -1 then 
						caster:ForceKill(false)
						items_table = {} 
						for i = 0, 23 do 
							local item = oldHero:GetItemInSlot( i ) 
							if item ~= nil then 
								items_table[item:GetName()] = item:GetCurrentCharges() 
								item:RemoveSelf() 
							end 
						end 
						local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
						newHero:SetGold(gold, false)	
						newHero:AddExperience(experience, 0, false, true)
						newHero:AddNewModifier( newHero, nil, "modifier_sound_attack", {} )
						for item,stacks in pairs(items_table) do 
							newHero:AddItemByName(item):SetCurrentCharges(stacks) 
						local Key = newHero:FindItemInInventory( "item_destroyer_stone" )
						if Key ~= nil then
						newHero:RemoveItem(Key)
						end 
					end 
				end
			UTIL_Remove(caster)
			essentials:Init()
		end
	end
end

function swap4(trigger)
	local caster = trigger.activator
	local level = caster:GetLevel()
	if caster ~= nil and level == 1 and caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local playerID = caster:GetPlayerID()
		local sid = PlayerResource:GetSteamAccountID(playerID)
		if Shop.pShop[sid].add_hero == false then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"Anakim_show", {})
		else
			local hRelay = Entities:FindByName( nil, "anakim_log" )
				hRelay:Trigger(nil,nil)
				local oldHero = caster--PlayerResource:GetSelectedHeroEntity(playerID)	
				local newHeroName = "npc_dota_hero_anakim"	
				local gold = oldHero:GetGold()
				local experience = oldHero:GetCurrentXP() 
				print("gold = "..gold.." exp = "..experience)	
				if playerID ~= nil and playerID ~= -1 then 
					caster:ForceKill(false)
					items_table = {} 
					for i = 0, 23 do 
						local item = oldHero:GetItemInSlot( i ) 
						if item ~= nil then 
							items_table[item:GetName()] = item:GetCurrentCharges() 
							item:RemoveSelf() 
						end 
					end 
					local newHero = PlayerResource:ReplaceHeroWith(playerID, newHeroName, 0, 0) 
					newHero:SetGold(gold, false)	
					newHero:AddExperience(experience, 0, false, true)
					for item,stacks in pairs(items_table) do 
						newHero:AddItemByName(item):SetCurrentCharges(stacks) 
					end 
				end
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"Anakim_hide", {})	
			UTIL_Remove(caster)
			essentials:Init()
		end
	end
end

function hide(trigger)
	local playerID = trigger.activator:GetPlayerID()
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID),"Anakim_hide", {})	
end

function Checkpoint_OnStartTouch( trigger )
	local sCheckpointTriggerName = thisEntity:GetName()
	local hBuilding = Entities:FindByName( nil, sCheckpointTriggerName .. "_building" )
	hBuilding:SetTeam( DOTA_TEAM_GOODGUYS )
	EmitGlobalSound( "DOTA_Item.Refresher.Activate" ) 
end
		
function off(event)
print("OFF BLAT")
	local unitu2 = Entities:FindByName( nil, "undy")
	unitu2:RemoveModifierByName("modifier_invulnerable")
	unitu2:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unitu2:RemoveModifierByName("modifier_magic_immune")
	local unitu3 = Entities:FindByName( nil, "lich2")
	unitu3:RemoveModifierByName("modifier_invulnerable")
	unitu3:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unitu3:RemoveModifierByName("modifier_magic_immune")
	local unitu4 = Entities:FindByName( nil, "storegga")
	unitu4:RemoveModifierByName("modifier_invulnerable")
	unitu4:RemoveModifierByName("modifier_medusa_stone_gaze_stone")
	unitu4:RemoveModifierByName("modifier_magic_immune")
end

function noheal(trigger)    -- где это?)
	local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
	ent:AddNewModifier( ent, self, "modifier_ice_blast", {} )
        return
    end
end

function nohealoff(trigger)
	local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
	ent:RemoveModifierByName( ent, self, "modifier_ice_blast", {} )
        return
    end
end

function invulnerable()
	local unita = Entities:FindByName( nil, "undy")
	unita:AddNewModifier( unita, nil, "modifier_invulnerable", { } )
	unita:AddNewModifier( unita, nil, "modifier_medusa_stone_gaze_stone", { } )
	
	local unitb = Entities:FindByName( nil, "lich2")
	unitb:AddNewModifier( unitb, nil, "modifier_invulnerable", { } )
	unitb:AddNewModifier( unitb, nil, "modifier_medusa_stone_gaze_stone", { } )
	
	local unitc = Entities:FindByName( nil, "storegga")
	unitc:AddNewModifier( unitc, nil, "modifier_invulnerable", { } )
	unitc:AddNewModifier( unitc, nil, "modifier_medusa_stone_gaze_stone", { } )
end

------------------------------------------------------------------------------------------------------
function nyxon()
	local unit = Entities:FindByName( nil, "NYX")
	unit:AddNewModifier( unit, nil, "modifier_invulnerable", {} )
	unit:AddNewModifier( unit, nil, "modifier_medusa_stone_gaze_stone", {} )
	unit:AddNewModifier( unit, nil, "modifier_magic_immune", {} )
	
	local unit2 = Entities:FindByName( nil, "NYX_2")
	unit2:AddNewModifier( unit2, nil, "modifier_invulnerable", {} )
	unit2:AddNewModifier( unit2, nil, "modifier_medusa_stone_gaze_stone", {} )
	unit2:AddNewModifier( unit2, nil, "modifier_magic_immune", {} )
end

------------------------------------------------------------------------------------------------------

function coom(event)
	Notifications:TopToAll({text="#soon", duration=5})	
end

--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

LinkLuaModifier( "fire_map_ability_modifier", "triggers", LUA_MODIFIER_MOTION_NONE )

function OnLavaEnter(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:AddNewModifier( ent, self, "fire_map_ability_modifier", {} )
        return
    end
end

function OnLavaExit(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
		ent:RemoveModifierByName("fire_map_ability_modifier") 
        return
    end
end

-------------------------------------------------------------------------------------------------------------

fire_map_ability_modifier = class({})

function fire_map_ability_modifier:OnCreated( kv )  
    if IsServer() then
        self:StartIntervalThink( 0.1 )
    end
end

function fire_map_ability_modifier:IsHidden()
	return false
end

function fire_map_ability_modifier:IsDebuff()
	return true
end

function fire_map_ability_modifier:IsPurgable()
	return false
end

function fire_map_ability_modifier:GetTexture()
    return "pit"
end

function fire_map_ability_modifier:OnIntervalThink()
    if IsServer() then
        if self:GetParent():IsAlive() then
        local hAttacker = self:GetParent()
        local damageTable = {
            victim = self:GetParent(),
            attacker = hAttacker,
            damage = 800,
            damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        }
        ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_trail_1.vpcf", PATTACH_ABSORIGIN , self:GetParent()) 
        ApplyDamage(damageTable)
        end
    end
end

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

LinkLuaModifier( "lava_map_ability_modifier", "triggers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "dmg_lava_map_ability_modifier", "triggers", LUA_MODIFIER_MOTION_NONE )

function OnSlowEnter(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
    ent:AddNewModifier( ent, self, "lava_map_ability_modifier", {} )
        return
    end
end

function OnSlowExit(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
    ent:RemoveModifierByName("lava_map_ability_modifier") 
        return
    end
end

function OnSlowEnter2(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
    ent:AddNewModifier( ent, self, "dmg_lava_map_ability_modifier", {} )
        return
    end
end

function OnSlowExit2(trigger)
    local ent = trigger.activator
    if not ent then return end
    if ent:IsAlive() then
    ent:RemoveModifierByName("dmg_lava_map_ability_modifier") 
        return
    end
end


-----------------------------------------------------------------------------------------------------
if dmg_lava_map_ability_modifier == nil then
    dmg_lava_map_ability_modifier = class({})
end

function dmg_lava_map_ability_modifier:OnCreated( kv )  
    if IsServer() then
        self:StartIntervalThink( 0.1 )
    end
end

function dmg_lava_map_ability_modifier:IsHidden() return false end
function dmg_lava_map_ability_modifier:IsDebuff() return true end

function dmg_lava_map_ability_modifier:IsPurgable()
	return false
end

function dmg_lava_map_ability_modifier:GetTexture()
    return "acid"
end

function dmg_lava_map_ability_modifier:OnCreated( kv )
	self.bonus_damage = -40
	self.bonus_attack_speed = -25
end

function dmg_lava_map_ability_modifier:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function dmg_lava_map_ability_modifier:GetModifierDamageOutgoing_Percentage( params )
	return self.bonus_damage
end

function dmg_lava_map_ability_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_attack_speed
end

---------------------------------------------------------------------------------------------------

if lava_map_ability_modifier == nil then
    lava_map_ability_modifier = class({})
end

function lava_map_ability_modifier:OnCreated( kv )  
    if IsServer() then
        self:StartIntervalThink( 0.1 )
    end
end

function lava_map_ability_modifier:IsHidden() return false end
function lava_map_ability_modifier:IsDebuff() return true end

function lava_map_ability_modifier:GetTexture()
    return "acid2"
end

function lava_map_ability_modifier:IsPurgable()
	return false
end

function lava_map_ability_modifier:OnIntervalThink()
    if IsServer() then
        if self:GetParent():IsAlive() then
        local hAttacker = self:GetParent()
        local damageTable = {
            victim = self:GetParent(),
            attacker = hAttacker,
            damage = 100, --100
            damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        }
        ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_loadout.vpcf", PATTACH_ABSORIGIN , self:GetParent()) 
        ApplyDamage(damageTable)
        end
    end
end