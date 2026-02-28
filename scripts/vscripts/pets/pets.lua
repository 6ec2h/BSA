require("drop")
LinkLuaModifier( "modifier_pets", "pets/pets", LUA_MODIFIER_MOTION_NONE )

pet = class({})

function pet:GetIntrinsicModifierName()
	return "modifier_pets"
end

-------------------------------------------------------------------------------

modifier_pets = class({})

function modifier_pets:IsHidden()
	return true
end

function modifier_pets:IsPurgable()
    return false
end

function modifier_pets:OnCreated()
    self:StartIntervalThink(0.1)
end

function modifier_pets:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING] = true,
	}
	return state
end

function modifier_pets:OnIntervalThink()
if not IsServer() then return end
	for i = 0, 5 do
	local item = self:GetCaster():GetItemInSlot(i)
		if item then
			if item:GetAbilityName() == "item_bones"
			--or item:GetAbilityName() == "item_egg" 
		--	or item:GetAbilityName() == "item_kamen_boga" 
			or item:GetAbilityName() == "item_ticket"
			or item:GetAbilityName() == "item_slot_block" then
				--print("u have")
			else
				self:GetCaster():DropItemAtPositionImmediate(item, self:GetCaster():GetAbsOrigin())
			end
		end
	end
			
	local items_on_the_ground = Entities:FindAllByClassnameWithin("dota_item_drop",self:GetCaster():GetOrigin(),900)
	for _,item in pairs(items_on_the_ground) do
		if item then
		local containedItem = item:GetContainedItem()	
		local item_name = containedItem:GetAbilityName()
		local item_position = spawnPoint

		if item_name == "item_bones"
			--or item_name == "item_egg" 
			--or item_name == "item_kamen_boga" 
			or item_name == "item_ticket" 
			or item_name == "item_slot_block" then
			
			ExecuteOrderFromTable({
			  UnitIndex = self:GetCaster():GetEntityIndex(),
			  TargetIndex = item:GetEntityIndex(),
			  OrderType = DOTA_UNIT_ORDER_PICKUP_ITEM,
			  Queue = queue,
			  })
			end
		end
    end
end