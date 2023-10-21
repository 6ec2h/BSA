naga_siren_mirror_image_lua = {}
naga_siren_mirror_image_lua.illusions = {}
LinkLuaModifier( "modifier_naga_siren_mirror_image_lua", "heroes/hero_naga/naga_siren_mirror_image_lua/naga_siren_mirror_image_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_illusion_naga_siren_mirror_image_lua", "heroes/hero_naga/naga_siren_mirror_image_lua/naga_siren_mirror_image_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function naga_siren_mirror_image_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_mirror_image.vpcf", context )
end

function naga_siren_mirror_image_lua:GetIntrinsicModifierName()
	return "modifier_naga_siren_mirror_image_lua"
end

function naga_siren_mirror_image_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "illusion_duration" )
	local outgoing = self:GetSpecialValueFor( "illusion_outgoing_damage" )
	local incoming = self:GetSpecialValueFor( "illusion_incoming_damage" )
	local distance = 72

	if self:GetCaster():FindAbilityByName("npc_dota_hero_naga_siren_6") ~= nil and self:GetCaster():FindAbilityByName("npc_dota_hero_naga_siren_6"):GetLevel() > 0 then
		incoming = incoming - 50
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_naga_siren_4") ~= nil and self:GetCaster():FindAbilityByName("npc_dota_hero_naga_siren_4"):GetLevel() > 0 then
		outgoing = outgoing + 50
	end

	for n,illusion in pairs(self.illusions) do
		if not illusion:IsNull() then
			illusion:ForceKill( false )
		end

		self.illusions[n] = nil	
	end
	
	
	-- create illusion
	local illusions = CreateIllusions(
		caster, -- hOwner
		caster, -- hHeroToCopy
		{
			outgoing_damage = outgoing,
			incoming_damage = incoming,
			-- duration = duration,
		}, -- hModiiferKeys
		1, -- nNumIllusions
		distance, -- nPadding
		false, -- bScramblePosition
		true -- bFindClearSpace
	)
	for _,illusion in pairs(illusions) do
		self:SetContextThink( DoUniqueString( "naga_siren_mirror_image_lua" ),function()
			illusion:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_illusion_naga_siren_mirror_image_lua", -- modifier name
				{} -- kv
			)
	
			-- Play effects
			local sound_cast = "Hero_NagaSiren.MirrorImage"
			EmitSoundOn( sound_cast, illusion )
			illusion:SetHealth(illusion:GetMaxHealth())
		end, FrameTime()*2)
		
		
	end
	self.illusions = illusions
end

function naga_siren_mirror_image_lua:IllusionDie()
	
end

modifier_illusion_naga_siren_mirror_image_lua = class({})

function modifier_illusion_naga_siren_mirror_image_lua:OnCreated()
	if not IsServer() then return end
	self.illusionMaxHealth = self:GetParent():GetMaxHealth()
	self.illusionArmorBase = self:GetParent():GetPhysicalArmorBaseValue()
	self.illusionAttackSpeed = self:GetParent():GetAttackSpeed()
	self.illusionDamageBase = (self:GetParent():GetBaseDamageMin() + self:GetParent():GetBaseDamageMax()) / 2
	self.illusionMoveSpeed = self:GetParent():GetMoveSpeedModifier(self:GetParent():GetBaseMoveSpeed(), false)
	self.illusionSpellAmplification = self:GetParent():GetSpellAmplification(false)
end

function modifier_illusion_naga_siren_mirror_image_lua:IsHidden()
	return true
end

function modifier_illusion_naga_siren_mirror_image_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_illusion_naga_siren_mirror_image_lua:GetModifierExtraHealthBonus()
	return self:GetCaster():GetMaxHealth() - self.illusionMaxHealth
end

function modifier_illusion_naga_siren_mirror_image_lua:GetModifierSpellAmplify_Percentage()
	if self.illusionSpellAmplification then
		return self:GetCaster():GetSpellAmplification(false) - self.illusionSpellAmplification
	end
	return 0
end

function modifier_illusion_naga_siren_mirror_image_lua:GetModifierBaseAttack_BonusDamage()
	if self.illusionDamageBase then
		return (self:GetCaster():GetBaseDamageMin() + self:GetCaster():GetBaseDamageMax()) / 2 - self.illusionDamageBase
	end
	return 0
end

function modifier_illusion_naga_siren_mirror_image_lua:GetModifierMoveSpeedBonus_Special_Boots()
	if self.illusionMoveSpeed then
    	return self:GetCaster():GetMoveSpeedModifier(self:GetCaster():GetBaseMoveSpeed(), false) - self.illusionMoveSpeed + 20
	end
	return 20
end

function modifier_illusion_naga_siren_mirror_image_lua:GetModifierAttackSpeedBonus_Constant()
	if self.illusionAttackSpeed then
		return self:GetCaster():GetAttackSpeed() - self.illusionAttackSpeed
	end
	return 0
end

function modifier_illusion_naga_siren_mirror_image_lua:OnDestroy()
	for n,illusion in pairs(self:GetAbility().illusions) do
		if illusion == self:GetParent() then
			self:GetAbility().illusions[n] = nil
			break
		end
	end
	self:GetAbility():UseResources(false, false, false, true)
end

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
