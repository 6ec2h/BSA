local MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9 = 10001

--------------------------------------------------------------------------------
modifier_naga_siren_mirror_image_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_naga_siren_mirror_image_lua:IsHidden()
	return true
end

function modifier_naga_siren_mirror_image_lua:IsDebuff()
	return false
end

function modifier_naga_siren_mirror_image_lua:IsStunDebuff()
	return false
end

function modifier_naga_siren_mirror_image_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_naga_siren_mirror_image_lua:OnCreated( kv )
	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function modifier_naga_siren_mirror_image_lua:OnIntervalThink()
	if not IsServer() then return end
	local illusions = self:GetAbility().illusions
	if self:GetCaster():IsAlive() == false and #illusions > 0 then
		for _,illusion in pairs(illusions) do
			illusion:ForceKill( false )
		end
	end
	if self:GetAbility():IsFullyCastable() and #illusions < 1 and self:GetParent():IsRealHero() and self:GetParent():IsAlive() == true then
		self:GetAbility():OnSpellStart()
		self:GetAbility():UseResources(true, false, false, false)
		self:GetAbility():StartCooldown( 1.0 )
	end
end

function modifier_naga_siren_mirror_image_lua:OnRefresh( kv )
	
end

function modifier_naga_siren_mirror_image_lua:OnRemoved()
end

function modifier_naga_siren_mirror_image_lua:OnDestroy()

end
