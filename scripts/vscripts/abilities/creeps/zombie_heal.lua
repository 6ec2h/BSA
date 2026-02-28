zombie_heal = class({})

LinkLuaModifier("modifier_zombie_heal", "abilities/creeps/zombie_heal", LUA_MODIFIER_MOTION_VERTICAL)

function zombie_heal:GetIntrinsicModifierName()
	return "modifier_zombie_heal"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------

modifier_zombie_heal = class({})

function modifier_zombie_heal:IsHidden()
	return true
end

function modifier_zombie_heal:IsPurgable()
	return false
end

function modifier_zombie_heal:OnCreated( kv )
	self:StartIntervalThink(1)
end

function modifier_zombie_heal:OnIntervalThink()
	local bResult = xpcall(function()
	if IsServer() then
	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetParent(), 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		if #units > 0 then
			for i = 1, #units do		
				if units[i] then 
					units[i]:Heal(3,self:GetParent())				
				end
			end
		end
	end
	end,
	function(e)
		print("-------------Error-------------")
		print(e)
		print("-------------Error-------------")
	end)  
	--дебаг
	
	--вызов вункции в которой может быть ошибка
	if bResult then
		--print("all ok")
	else
		print("error")
	end			
end
