modifier_earthshaker_aftershock_lua = class({})

function modifier_earthshaker_aftershock_lua:IsHidden()
	return true
end

function modifier_earthshaker_aftershock_lua:IsPurgable()
	return false
end

function modifier_earthshaker_aftershock_lua:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "aftershock_range" ) -- special value

	if IsServer() then
		local damage = self:GetAbility():GetAbilityDamage() -- special value
		self.duration = self:GetAbility():GetDuration() -- special value
		
		local talent = self:GetCaster():FindAbilityByName("special_bonus_earthshaker_tal2")
		if talent ~= nil and talent:GetLevel() > 0 then
			damage = damage + 50
		else
			damage = damage
		end

		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}
	end
end

function modifier_earthshaker_aftershock_lua:OnRefresh( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "aftershock_range" ) -- special value

	if IsServer() then
		local damage = self:GetAbility():GetAbilityDamage() -- special value
		self.duration = self:GetAbility():GetDuration() -- special value

		self.damageTable.damage = damage
	end
end

function modifier_earthshaker_aftershock_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

local ignoredAbilityNames = {
	["techies_focused_detonate_lua"] = true,
	["ability_capture_lua"] = true,
	["new_year_snowball"] = true,
}

function modifier_earthshaker_aftershock_lua:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent() or params.ability:IsItem() or ignoredAbilityNames[params.ability:GetName()] then return end

		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			self:GetCaster():GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(
				self:GetParent(), -- player source
				self:GetAbility(), -- ability source
				"modifier_stunned", -- modifier name
				{duration = self.duration * (1 - enemy:GetStatusResistance())}
			)

			self.damageTable.victim = enemy
			ApplyDamage(self.damageTable)
		end
		self:PlayEffects()
	end
end

function modifier_earthshaker_aftershock_lua:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end