modifier_axe_counter_helix_lua = class({})

function modifier_axe_counter_helix_lua:IsHidden()
	return true
end

function modifier_axe_counter_helix_lua:IsPurgable()
	return false
end

function modifier_axe_counter_helix_lua:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("AbilityCastRange")

	if not IsServer() then return end
	
	self.chance = self:GetAbility():GetSpecialValueFor("trigger_chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_axe_counter_helix_lua:OnRefresh()
	if not IsServer() then return end
	
	self.chance = self:GetAbility():GetSpecialValueFor("trigger_chance")
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
end

function modifier_axe_counter_helix_lua:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end

local function hasTalent(unit, talentName)
	local talent = unit:FindAbilityByName(talentName)

    return talent and talent:GetLevel() > 0 or false
end

function modifier_axe_counter_helix_lua:OnAttackLanded(params)
	if not IsServer() then return end
	
	local ability = self:GetAbility()

	if not ability or not ability:IsFullyCastable() then return end

	local caster = self:GetCaster()

	if not caster or caster:PassivesDisabled() then return end

	if params.attacker ~= caster or not hasTalent(caster, "special_bonus_unique_axe_4") then
		if params.target ~= caster then return end
		if params.attacker:IsBuilding() then return end
		if params.attacker:IsOther() then return end
		if params.attacker:GetTeamNumber() == params.target:GetTeamNumber() then return end
	end
	
	if not hasTalent(caster, "special_bonus_unique_axe_1") or not caster:HasModifier("modifier_axe_berserkers_call_lua") then
		if RandomInt(1, 100) > self.chance then return end
	end

	local damage = self.damage

	if hasTalent(caster, "special_bonus_unique_axe_3") then
		damage = damage + caster:GetBaseDamageMin() * self:GetAbility():GetSpecialValueFor("base_damage") / 100
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

---------------------------------------------------
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = ability, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --Optional.
	}

	-- damage
	for i = 1, #enemies do
		damageTable.victim = enemies[i]
		ApplyDamage(damageTable)
	end

	-- cooldown
	if not caster:HasModifier("modifier_axe_enrage_lua") then
		ability:UseResources( false,false, false, true )
	end

	-- effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------

function modifier_axe_counter_helix_lua:PlayEffects2( target )
	-- get resource
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


-- Graphics & Animations
function modifier_axe_counter_helix_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf"
	
	local sound_cast = "Hero_Axe.CounterHelix"
	
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast2 )
	
	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
 0 then return true end
    end
    return false
end