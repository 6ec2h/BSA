LinkLuaModifier( "modifier_dummy", "modifiers/modifier_dummy", LUA_MODIFIER_MOTION_NONE )

item_bkb_flask = {}

function item_bkb_flask:GetAOERadius() return self:GetSpecialValueFor("radius") end

function item_bkb_flask:OnSpellStart()
if GameRules:IsCheatMode() and not IsInToolsMode() then return end
	local projectile_name = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf"
	local projectile_speed = 600
	
	local dummy = CreateUnitByName("npc_dummy_unit", self:GetCursorPosition(), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
	dummy:AddNewModifier(self:GetCaster(),self,"modifier_dummy",{} )
	
	local info = {
		Target = dummy,
		Source = self:GetCaster(),
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,
	}
	
	ProjectileManager:CreateTrackingProjectile(info)
	EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Throw", self:GetCaster() )
	local playerID = self:GetCaster():GetPlayerID()
	self:SpendCharge()
end

function item_bkb_flask:OnProjectileHit( target, location )
	if not target then return end
	
	local allies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false )
	for _,ally in pairs(allies) do
		ally:AddNewModifier( self:GetCaster(), nil, "modifier_black_king_bar_immune", {duration = 4})
	end
	
	target:ForceKIll(false)
	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetCaster())
end