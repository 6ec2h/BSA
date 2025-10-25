LinkLuaModifier( "modifier_magic_resist_lua", "abilities/ability_capture", LUA_MODIFIER_MOTION_NONE )

ability_capture_lua = class({})

function ability_capture_lua:GetIntrinsicModifierName()
	return "modifier_magic_resist_lua"
end

function ability_capture_lua:GetChannelTime()
	return 3
end

function ability_capture_lua:OnHeroLevelUp()
end

function ability_capture_lua:GetChannelAnimation()
	return ACT_DOTA_TELEPORT
end

function ability_capture_lua:CastFilterResultLocation(pos)
	self.pos = pos
end

function ability_capture_lua:OnSpellStart(keys)
	StartSoundEvent("Outpost.Channel", self:GetCaster())
end

function ability_capture_lua:OnChannelFinish( bInterrupted )
	if not bInterrupted then
		local items_on_the_ground = Entities:FindAllByClassnameWithin("dota_item_drop", self.pos, 200)
		for _,item_ground in pairs(items_on_the_ground) do
			if item_ground then
				local item = item_ground:GetContainedItem()
				local item_name = item:GetAbilityName()
				if item_name == "item_tombstone" then
					local hero = item:GetPurchaser()
					local point = self.pos
					local hRelay = Entities:FindByName( nil, "logic_teleport" )
					hRelay:Trigger(nil,nil)	
					hero:RespawnHero(false, false)
					hero:SetAbsOrigin( point )
					FindClearSpaceForUnit(hero, point, true) 
					hero:Stop()
					hero:RemoveModifierByName("modifier_fountain_invulnerability")
					UTIL_Remove(item_ground)
				end
			end
		end
	end
	StopSoundEvent("Outpost.Channel", self:GetCaster())
end

--------------------------

modifier_magic_resist_lua = class({})

function modifier_magic_resist_lua:IsHidden()
	return true
end

function modifier_magic_resist_lua:IsPurgeException()
	return false
end	

function modifier_magic_resist_lua:IsPurgable()
	return false
end

function modifier_magic_resist_lua:RemoveOnDeath()
	return false
end

function modifier_magic_resist_lua:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
    }
end

function modifier_magic_resist_lua:GetModifierMagicalResistanceDirectModification()
	return -0.1 * self:GetParent():GetIntellect(true)
end

