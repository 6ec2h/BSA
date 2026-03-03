item_add_spell = class({})

function item_add_spell:OnSpellStart()
	if IsServer() then
		local pid = self:GetCaster():GetPlayerID()	
		local hHero = PlayerResource:GetSelectedHeroEntity(pid)
		
		hHero.count = 1
		HeroBuilder:ShowAbilityForSelect(hHero, pid)
		UTIL_Remove(self)
	end
end