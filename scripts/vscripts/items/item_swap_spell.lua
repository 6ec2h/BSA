item_swap_spell = class({})

function item_swap_spell:OnSpellStart()
	if IsServer() then
		local pid = self:GetCaster():GetPlayerID()	
		local hHero = PlayerResource:GetSelectedHeroEntity(pid)
		local target = self:GetCursorTarget()
		if target:IsRealHero() and not target:IsTempestDouble() and not target:IsIllusion() then
			local tpid = target:GetPlayerID()	
		
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(tpid),"ShowSwapHeroesSkills", _G.hero_skills[pid])
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"ShowSwapHeroesSkills", _G.hero_skills[tpid])
		
			UTIL_Remove(self)
		end
	end
end