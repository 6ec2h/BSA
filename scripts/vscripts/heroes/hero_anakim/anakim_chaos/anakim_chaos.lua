LinkLuaModifier( "modifier_anakim_chaos", "heroes/hero_anakim/anakim_chaos/anakim_chaos", LUA_MODIFIER_MOTION_NONE )

anakim_chaos = class({})

function anakim_chaos:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function anakim_chaos:Precache( context )
	PrecacheResource( "particle", "particles/anakim/anakim_chaos.vpcf", context )
end


function anakim_chaos:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(caster, self, "modifier_anakim_chaos", { duration = duration })
	end
	self:PlayEffects( point )
end

function anakim_chaos:PlayEffects( point )
	local radius = self:GetSpecialValueFor("radius")
	local effect_cast = ParticleManager:CreateParticle( "particles/anakim/anakim_chaos.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetCaster():EmitSound("DOTA_Item.VeilofDiscord.Activate")
end

----------------------------------------------------------------------------

modifier_anakim_chaos = class({})

function modifier_anakim_chaos:IsDebuff() return true end
function modifier_anakim_chaos:IsHidden() return false end
function modifier_anakim_chaos:IsPurgable() return false end

function modifier_anakim_chaos:OnCreated()
	if not IsServer() then return end

	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	local ability = self:GetCaster():FindAbilityByName("special_bonus_anakim_tal2")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.spell_amp = self.spell_amp + 6--ability:GetSpecialValueFor("value")
	end
end

function modifier_anakim_chaos:CheckState()
	local state = {
		[MODIFIER_STATE_BLIND] = true,
	}
	return state
end

function modifier_anakim_chaos:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_anakim_chaos:GetModifierIncomingDamage_Percentage(keys)
	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL and keys.attacker == self:GetCaster() then
		return self.spell_amp
	end
end
