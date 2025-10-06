item_reroll = class({})

function item_reroll:OnSpellStart()
	if IsServer() then
		local pid = self:GetCaster():GetPlayerID()	
		local hHero = PlayerResource:GetSelectedHeroEntity(pid)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"ShowRerollSkills", _G.hero_skills[pid])
		UTIL_Remove(self)	
	end
end