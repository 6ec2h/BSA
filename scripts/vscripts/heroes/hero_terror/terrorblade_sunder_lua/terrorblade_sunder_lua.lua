terrorblade_sunder_lua = class({})
LinkLuaModifier( "modifier_terrorblade_sunder_lua", "heroes/hero_terror/terrorblade_sunder_lua/terrorblade_sunder_lua", LUA_MODIFIER_MOTION_NONE )

function terrorblade_sunder_lua:OnSpellStart()
	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	caster:EmitSound("Hero_Terrorblade.Sunder.Cast")
	local radius = self:GetSpecialValueFor( "range" )
	local duration = self:GetSpecialValueFor( "duration" )
	local sunderdamage = self:GetSpecialValueFor( "damage" )
	
	local talent = self:GetCaster():FindAbilityByName("special_bonus_terrorblade_tal5")
	if talent ~= nil and talent:GetLevel() > 0 then 
		duration = duration + 5
	end
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_CREEP,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	caster:AddNewModifier(caster, self, "modifier_terrorblade_sunder_lua", {duration = duration })
	local modifier = caster:AddNewModifier(caster, caster, "modifier_terrorblade_sunder_lua", nil)
	caster:SetModifierStackCount("modifier_terrorblade_sunder_lua", caster, #enemies)
	
	for _,enemy in pairs(enemies) do
		ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = ability, damage = sunderdamage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION})
	end
end

------------------------------------------------------------
modifier_terrorblade_sunder_lua = class({})

function modifier_terrorblade_sunder_lua:IsHidden()
	return false
end

function modifier_terrorblade_sunder_lua:IsPurgable()
	return false
end

function modifier_terrorblade_sunder_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_terrorblade_sunder_lua:OnCreated()
	if IsServer() then
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
		
		Timers:CreateTimer(0.1, function()
			sunder_hp_stack = self:GetStackCount()*self.damage
			self:GetCaster():CalculateStatBonus(true)
			-- self:GetCaster():SetMaxHealth(self:GetCaster():GetMaxHealth()+sunder_hp_stack)
		return nil
		end)
	end
end

function modifier_terrorblade_sunder_lua:OnRefresh()
	if IsServer() then
		-- self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		-- self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
		
		Timers:CreateTimer(0.1, function()
			sunder_hp_stack = self:GetStackCount()*self.damage
			self:GetCaster():CalculateStatBonus(true)
			-- self:GetCaster():SetMaxHealth(self:GetCaster():GetMaxHealth()+sunder_hp_stack)
		return nil
		end)
	end
end

if IsServer() then
	function modifier_terrorblade_sunder_lua:GetModifierBaseAttack_BonusDamage()
		sunder_damage = self:GetStackCount()*self.bonus_damage 
		return sunder_damage
	end

	function modifier_terrorblade_sunder_lua:GetModifierExtraHealthBonus()

		return sunder_hp_stack
	end
end