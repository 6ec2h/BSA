LinkLuaModifier( "modifier_dummy", "modifiers/modifier_dummy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_immune_bkb_flask", "items/item_bkb_flask", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_immune_bkb_flask_cd", "items/item_bkb_flask", LUA_MODIFIER_MOTION_NONE )

item_bkb_flask = class({})

function item_bkb_flask:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function item_bkb_flask:OnSpellStart()
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

	EmitSoundOn("Hero_Alchemist.UnstableConcoction.Throw", self:GetCaster())
end

function item_bkb_flask:OnProjectileHit(target, location)
	if not target then return end
	local allies = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, target:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, 0, false )
	for _,ally in pairs(allies) do
		if not ally:HasModifier("modifier_immune_bkb_flask_cd") then
			ally:AddNewModifier(target, nil, "modifier_magic_immune", {duration = 3} )
			ally:AddNewModifier(target, nil, "modifier_immune_bkb_flask", {duration = 3} )
			ally:AddNewModifier(target, nil, "modifier_immune_bkb_flask_cd", {duration = 90} )
		end
	end
	
	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", target)	
	self:SpendCharge(0)
end

----------------------------------------------------------------------------------

modifier_immune_bkb_flask_cd = class({})

function modifier_immune_bkb_flask_cd:IsHidden() return false end
function modifier_immune_bkb_flask_cd:IsPurgable() return false end
function modifier_immune_bkb_flask_cd:IsDebuff() return false end
function modifier_immune_bkb_flask_cd:RemoveOnDeath() return false end

function modifier_immune_bkb_flask_cd:GetTexture()
	return "item_bkb_flask"
end

----------------------------------------------------------------------------------

modifier_immune_bkb_flask = class({})

function modifier_immune_bkb_flask:IsHidden() return true end
function modifier_immune_bkb_flask:IsPurgable() return false end
function modifier_immune_bkb_flask:IsDebuff() return false end


function modifier_immune_bkb_flask:GetTexture()
	return "item_bkb_flask"
end

function modifier_immune_bkb_flask:GetEffectName()
    return "particles/bkb_flask.vpcf"
end

function modifier_immune_bkb_flask:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end