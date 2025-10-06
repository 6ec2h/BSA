LinkLuaModifier( "modifier_item_dark_moon_shard", "items/custom_items/item_dark_moon_shard", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_item_dark_moon_shard_passive", "items/custom_items/item_dark_moon_shard", LUA_MODIFIER_MOTION_BOTH )


item_dark_moon_shard = class({})

function item_dark_moon_shard:GetIntrinsicModifierName()
   return "modifier_item_dark_moon_shard_passive"
end

function item_dark_moon_shard:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() then 
		    if hCaster:HasModifier("modifier_item_dark_moon_shard") then
				rules:DisplayError(hPlayer:GetPlayerID(), "#cant_modifier_item_dark_moon_shard")
				return
            end
            if hCaster:HasModifier("modifier_alchemist_chemical_rage_lua") then
				rules:DisplayError(hPlayer:GetPlayerID(), "#cant_modifier_alchemist_chemical_rage_lua")
				return
            end
            if hCaster:HasModifier("modifier_mars_lil") then
               rules:DisplayError(hPlayer:GetPlayerID(), "#cant_modifier_mars_lil")
               return
            end
            hCaster:AddNewModifier(hCaster, self, "modifier_item_dark_moon_shard", {})
            self:SpendCharge(0)
            EmitSoundOn("Item.MoonShard.Consume", hCaster)
			-- Util:RecordConsumableItem(hCaster:GetPlayerOwnerID(),"item_dark_moon_shard")
		end
	end
end

-------------------------------------------------------
modifier_item_dark_moon_shard = class({})

function modifier_item_dark_moon_shard:IsHidden()
	return false
end

function modifier_item_dark_moon_shard:GetTexture()
	return "item_dark_moon_shard"
end


function modifier_item_dark_moon_shard:IsPermanent()
	return true
end


function modifier_item_dark_moon_shard:IsPurgable()
	return false
end

function modifier_item_dark_moon_shard:OnCreated()
	local flBaseAttackTime = self:GetParent():GetBaseAttackTime()
    local nbaseAttackReduction = 27
    if self:GetAbility() then
       nbaseAttackReduction = self:GetAbility():GetSpecialValueFor("base_attack_time_reduction")
    end
    self.flBaseAttackTime = flBaseAttackTime* (100-nbaseAttackReduction)/100
end



function modifier_item_dark_moon_shard:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}
	return funcs
end


function modifier_item_dark_moon_shard:GetModifierBaseAttackTimeConstant()
    
    if self.flBaseAttackTime then
       return self.flBaseAttackTime
    end

end

-------------------------------------------------------

modifier_item_dark_moon_shard_passive = class({})
function modifier_item_dark_moon_shard_passive:IsPurgable() return false end
function modifier_item_dark_moon_shard_passive:IsPurgeException() return false end
function modifier_item_dark_moon_shard_passive:IsHidden() return true end
function modifier_item_dark_moon_shard_passive:RemoveOnDeath() return false end
function modifier_item_dark_moon_shard_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_dark_moon_shard_passive:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_item_dark_moon_shard_passive:GetModifierAttackSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("passive_attack_speed") end
end