omniknight_repel_lua = class({})
LinkLuaModifier( "modifier_omniknight_repel_lua", "heroes/hero_omniknight/omniknight_repel_lua/modifier_omniknight_repel_lua", LUA_MODIFIER_MOTION_NONE )

function omniknight_repel_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_omniknight_int2")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_omniknight_int2"):GetLevel() > 0 then
			return self.BaseClass.GetCooldown(self, level) - 5
		end
	end
	return self.BaseClass.GetCooldown(self, level)
end

function omniknight_repel_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local buffDuration = self:GetSpecialValueFor("duration")

	target:Purge(false, true, false, true, false)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_omniknight_repel_lua", -- modifier name
		{ duration = buffDuration } -- kv
	)

	-- Play Effects
	self:PlayEffects()
end

function omniknight_repel_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end