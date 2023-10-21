LinkLuaModifier( "modifier_swap2", "items/item_swap2_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_swap2_buff", "items/item_swap2_lua", LUA_MODIFIER_MOTION_NONE )

item_swap2_lua = class({})


function item_swap2_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		local damage = hCaster:GetBaseDamageMin()
			if damage > 20 then
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() then 
		    if hCaster:HasModifier("modifier_swap2") then
               local hModifierAegis = hCaster:FindModifierByName("modifier_swap2")
               local nCurrentStack = hModifierAegis:GetStackCount()
               hModifierAegis:SetStackCount(nCurrentStack+1)
		    else
                local hModifierAegis = hCaster:AddNewModifier(hCaster, nil, "modifier_swap2", {})
                hModifierAegis:SetStackCount(1)
		    end
		    self:SpendCharge()
		    EmitSoundOn("DOTA_Item.Refresher.Activate", hCaster)
		    local nParticle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_timer.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
			ParticleManager:ReleaseParticleIndex( nParticle );
		end
	end
end
end

-----------------------------------------------------------------
-----------------------------------------------------------------

modifier_swap2 = class({})

function modifier_swap2:IsHidden()
	return false
end

function modifier_swap2:IsPurgable()
	return false
end


function modifier_swap2:IsPermanent()
	return true
end

function modifier_swap2:GetTexture()
	return "swap2"
end

function modifier_swap2:OnCreated( kv )
	self.bonus_damage = -20
	self.bonus_attack_speed = 10
end

function modifier_swap2:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_swap2:GetModifierBaseAttack_BonusDamage( params )
	local nStackCount = self:GetStackCount()
	local da = self.bonus_damage * nStackCount
	return da
end

function modifier_swap2:GetModifierAttackSpeedBonus_Constant( params )
	local nStackCount = self:GetStackCount()
	local da = self.bonus_attack_speed * nStackCount
	return da
end

function modifier_swap2:OnDeath(keys)
	if IsServer() then
	   if keys.unit == self:GetParent() then
	      
			  local nStackCount = self:GetStackCount()
			  if nStackCount>=1 then
			  	 self:SetStackCount(nStackCount-0)
			  end
		  end
	   end
end

-----------------------------------------------------------------
-----------------------------------------------------------------

modifier_aegis_buff = class({})

function modifier_aegis_buff:IsDebuff()
	return false
end
function modifier_aegis_buff:GetTexture()
	return "omniknight_repel"
end

function modifier_aegis_buff:OnCreated(table)
     local nWingsParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
     ParticleManager:SetParticleControl(nWingsParticleIndex, 0, self:GetParent():GetAbsOrigin())
     ParticleManager:SetParticleControlEnt(nWingsParticleIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
     self:AddParticle(nWingsParticleIndex, false, false, -1, false, false)    

    -- Halo particle
    local nHaloParticleIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_halo_buff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(nHaloParticleIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)    
    self:AddParticle(nHaloParticleIndex, false, false, -1, false, false)    
end

function modifier_aegis_buff:DeclareFunctions()
  local funcs = 
  {
       MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
       MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  }

  return funcs
end


function modifier_aegis_buff:GetModifierIncomingDamage_Percentage()
     return -65
end

function modifier_aegis_buff:GetModifierTotalDamageOutgoing_Percentage()
     return 100
end