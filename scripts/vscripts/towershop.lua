LinkLuaModifier( "modifier_shopkeeper", "modifiers/modifier_shopkeeper", LUA_MODIFIER_MOTION_NONE )

if IsServer() then
if not towershop then
	towershop = class({})
end

_G.nPlayers = 0
_G.resources = {}     
                                       			

items = LoadKeyValues("scripts/kv/items.txt")                           
costs = LoadKeyValues("scripts/kv/itemscosts.txt")
ingredients = LoadKeyValues("scripts/kv/itemsingredients.txt")

function towershop:FillingNetTables()                                      
    for shop, item in pairs(items) do
        CustomNetTables:SetTableValue("items",shop,item)
    end
    for item, cost in pairs(costs) do
        CustomNetTables:SetTableValue("itemscost",item,cost)
    end
    for item, ingredient in pairs(ingredients) do
        CustomNetTables:SetTableValue("itemsingredients",item,ingredient)
    end
end

function CDOTA_BaseNPC_Hero:ChangeWood(amount)
    local pid = self:GetPlayerID()
	_G.resources[pid]["wood"] = _G.resources[pid]["wood"] + math.floor(amount)
	_G.resources[pid]["da"] = _G.resources[pid]["da"] + math.floor(amount)
	
	print(_G.resources[pid]["da"] )
	print("da")
	print(_G.resources[pid]["wood"] )
   -- self.res["wood"] = self.res["wood"] + math.floor(amount)
     CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"ChangeWood",{wood = _G.resources[pid]["wood"]})
end

function towershop:StartGame()                     
 -- for playerid = 0, 4 do   
  for playerid = 0, DOTA_MAX_TEAM_PLAYERS-1 do
    _G.resources[playerid] = {}
    _G.resources[playerid]["wood"] = 0               
    _G.resources[playerid]["da"] = 0      	
  end
  
	CustomGameEventManager:RegisterListener("BuyItem2", Dynamic_Wrap(towershop, 'BuyItem2'))        
	CustomGameEventManager:RegisterListener("UnEquip", Dynamic_Wrap(towershop, 'UnEquip'))
	
	local blacksmith = CreateUnitByName("blacksmith", Vector(-14563,-15426,256), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith:AddNewModifier(blacksmith, nil, "modifier_shopkeeper", {})
	blacksmith:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith:StartGesture(ACT_DOTA_IDLE)
	blacksmith:SetAngles(0,-180,0)
	blacksmith:AddNewModifier(blacksmith,nil,"modifier_shop",{})
	
	local blacksmith2 = CreateUnitByName("blacksmith", Vector(-8997,-2416,146), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith2:AddNewModifier(blacksmith2, nil, "modifier_shopkeeper", {})
	blacksmith2:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith2:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith2:StartGesture(ACT_DOTA_IDLE)
	blacksmith2:SetAngles(0,-180,0)
	blacksmith2:AddNewModifier(blacksmith2,nil,"modifier_shop",{})
	
	local blacksmith3 = CreateUnitByName("blacksmith", Vector(-14975,-1812,562), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith3:AddNewModifier(blacksmith3, nil, "modifier_shopkeeper", {})
	blacksmith3:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith3:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith3:StartGesture(ACT_DOTA_IDLE)
	blacksmith3:SetAngles(0,-180,0)
	blacksmith3:AddNewModifier(blacksmith3,nil,"modifier_shop",{})
	
	local blacksmith4 = CreateUnitByName("blacksmith", Vector(-7773,9871,384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith4:AddNewModifier(blacksmith4, nil, "modifier_shopkeeper", {})
	blacksmith4:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith4:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith4:StartGesture(ACT_DOTA_IDLE)
	blacksmith4:SetAngles(0,270,0)
	blacksmith4:AddNewModifier(blacksmith4,nil,"modifier_shop",{})
	
	local blacksmith5 = CreateUnitByName("blacksmith", Vector(-3486,15458,256), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith5:AddNewModifier(blacksmith5, nil, "modifier_shopkeeper", {})
	blacksmith5:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith5:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith5:StartGesture(ACT_DOTA_IDLE)
	blacksmith5:SetAngles(0,-180,0)
	blacksmith5:AddNewModifier(blacksmith5,nil,"modifier_shop",{})
	
	local blacksmith6 = CreateUnitByName("blacksmith", Vector(-5385,3081,384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith6:AddNewModifier(blacksmith6, nil, "modifier_shopkeeper", {})
	blacksmith6:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith6:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith6:StartGesture(ACT_DOTA_IDLE)
	blacksmith6:SetAngles(0,0,0)
	blacksmith6:AddNewModifier(blacksmith6,nil,"modifier_shop",{})
	
	local blacksmith7 = CreateUnitByName("blacksmith", Vector(-4411,-10001,256), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith7:AddNewModifier(blacksmith7, nil, "modifier_shopkeeper", {})
	blacksmith7:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith7:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith7:StartGesture(ACT_DOTA_IDLE)
	blacksmith7:SetAngles(0,-180,0)
	blacksmith7:AddNewModifier(blacksmith7,nil,"modifier_shop",{})
	
	local blacksmith8 = CreateUnitByName("blacksmith", Vector(-233,736,384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith8:AddNewModifier(blacksmith8, nil, "modifier_shopkeeper", {})
	blacksmith8:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith8:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith8:StartGesture(ACT_DOTA_IDLE)
	blacksmith8:SetAngles(0,90,0)
	blacksmith8:AddNewModifier(blacksmith8,nil,"modifier_shop",{})
	
	local blacksmith9 = CreateUnitByName("blacksmith", Vector(435,8697,384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith9:AddNewModifier(blacksmith9, nil, "modifier_shopkeeper", {})
	blacksmith9:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith9:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith9:StartGesture(ACT_DOTA_IDLE)
	blacksmith9:SetAngles(0,90,0)
	blacksmith9:AddNewModifier(blacksmith9,nil,"modifier_shop",{})
	
	local blacksmith10 = CreateUnitByName("blacksmith", Vector(14399,14161,128), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith10:AddNewModifier(blacksmith10, nil, "modifier_shopkeeper", {})
	blacksmith10:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith10:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith10:StartGesture(ACT_DOTA_IDLE)
	blacksmith10:SetAngles(0,90,0)
	blacksmith10:AddNewModifier(blacksmith10,nil,"modifier_shop",{})
	
	local blacksmith11 = CreateUnitByName("blacksmith", Vector(13920,4681,384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith11:AddNewModifier(blacksmith11, nil, "modifier_shopkeeper", {})
	blacksmith11:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith11:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith11:StartGesture(ACT_DOTA_IDLE)
	blacksmith11:SetAngles(0,90,0)
	blacksmith11:AddNewModifier(blacksmith11,nil,"modifier_shop",{})	
	
	local blacksmith12 = CreateUnitByName("blacksmith", Vector(14215,-8047,512), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith12:AddNewModifier(blacksmith12, nil, "modifier_shopkeeper", {})
	blacksmith12:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith12:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith12:StartGesture(ACT_DOTA_IDLE)
	blacksmith12:SetAngles(0,90,0)
	blacksmith12:AddNewModifier(blacksmith12,nil,"modifier_shop",{})
end

function towershop:BuyItem2(t)                                             
  local item = items[t.shop][t.itemid]                                          
  local cost = costs[tostring(item .. "_" .. t.itemid)] or nil                
  if cost == nil and costs[item] ~= nil then                                    
    cost = costs[item]
  elseif cost == nil and costs[item] == nil then
    cost = {}
    cost["gold"] = 0
    cost["wood"] = 0
  end
  local pid = t.PlayerID                                                       
  local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)                
  local currentgold = PlayerResource:GetGold(pid)
  local currentwood = _G.resources[pid]["da"]       

	print(_G.resources[pid]["da"] )

	print(_G.resources[pid]["wood"] )

  local needingredients = ingredients[tostring(item .. "_" .. t.itemid)] or nil  
 
  if cost["gold"] or 0 <= currentgold and cost["wood"] or 0 <= currentwood then   

  if currentwood >= 0 then

	hero:SpendGold(cost["gold"] or 0, DOTA_ModifyGold_Unspecified)
     _G.resources[pid]["wood"] = _G.resources[pid]["wood"] - (cost["wood"] or 0)
     _G.resources[pid]["da"] = _G.resources[pid]["da"] - (cost["wood"] or 0)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"ChangeWood",{wood = _G.resources[pid]["wood"]})
	local purchaseditem = CreateItem(item, hero, hero)
	hero:AddItem(purchaseditem)  
    end
	end
end


function towershop:HasEquippedWeapons(hero,whatweapon)        ----НЕ НУЖНО
  for key,weapon in pairs(WeaponsModifierTable[whatweapon]) do
    if hero:HasModifier(weapon) then
      return true
    end
  end
  return false
end
function towershop:IsRejectAbility(ability)
  for key,ab in pairs(RejectingStatGainAbilities) do
    if ability == ab then
      return true
    end
  end
  return false
end

function towershop:UnEquip(t)
  local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
  local slot = t.slot
  if _G.resources[t.PlayerID]["equiped"][slot] ~= "" then
    hero:RemoveModifierByName("modifier_" .. _G.resources[t.PlayerID]["equiped"][slot])
      local item = CreateItem(_G.resources[t.PlayerID]["equiped"][slot], hero, hero)
      _G.resources[t.PlayerID]["equiped"][slot] = ""
      hero:AddItem(item)
      item:SetPurchaseTime(0)
  end
end

function towershop:enoughingrediens(hero,ingredient,value)          
  local inventory = { hero:GetItemInSlot(0), hero:GetItemInSlot(1), hero:GetItemInSlot(2), hero:GetItemInSlot(3), hero:GetItemInSlot(4), hero:GetItemInSlot(5), hero:GetItemInSlot(6), hero:GetItemInSlot(7), hero:GetItemInSlot(8),}
  for k,v in pairs(inventory) do
    if v:GetName() == ingredient then
      if v:GetCurrentCharges() >= value then
        return true
      end
    end
  end
  return false
end

function towershop:spendingredient(hero,ingredient,value)          
  local inventory = { hero:GetItemInSlot(0), hero:GetItemInSlot(1), hero:GetItemInSlot(2), hero:GetItemInSlot(3), hero:GetItemInSlot(4), hero:GetItemInSlot(5), hero:GetItemInSlot(6), hero:GetItemInSlot(7), hero:GetItemInSlot(8),}
  for k,v in pairs(inventory) do
    if v:GetName() == ingredient then
      if v:GetCurrentCharges() >= value then
        if v:GetCurrentCharges() == value then
          v:RemoveSelf()
        else
          v:SetCurrentCharges(v:GetCurrentCharges() - value)
        end
      end
    end
  end
end
end