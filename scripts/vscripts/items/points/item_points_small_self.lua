if item_points_small_self == nil then
	item_points_small_self = class({})
end

function item_points_small_self:OnSpellStart()
	self:GetCaster():ChangeWood(self:GetSpecialValueFor("wood"))
	self:GetCaster():EmitSoundParams( "DOTA_Item.InfusedRaindrop", 0, 0.5, 0)
	self:SpendCharge()
end