LinkLuaModifier( "modifier_naga_siren_rip_tide_lua", "heroes/hero_naga/naga_siren_rip_tide_lua/naga_siren_rip_tide_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_naga_siren_rip_tide_lua_debuff", "heroes/hero_naga/naga_siren_rip_tide_lua/naga_siren_rip_tide_lua", LUA_MODIFIER_MOTION_NONE )

naga_siren_rip_tide_lua = {}
naga_siren_rip_tide_lua.illusions = {}
function naga_siren_rip_tide_lua:GetIntrinsicModifierName()
	return "modifier_naga_siren_rip_tide_lua"
end

modifier_naga_siren_rip_tide_lua = {}

function modifier_naga_siren_rip_tide_lua:IsHidden()
	return false
end

function modifier_naga_siren_rip_tide_lua:IsDebuff()
	return false
end

function modifier_naga_siren_rip_tide_lua:IsPurgable()
	return false
end

function modifier_naga_siren_rip_tide_lua:OnCreated( kv )
    if not IsServer() then return end
    self.mainAbility = self:GetAbility()
    self.mainModifier = self
    if self:GetParent():IsIllusion() then
        local owner = self:GetParent():GetPlayerOwner() -- Получение владельца иллюзии
        self.ownerHero = owner:GetAssignedHero() -- Получение героя-владельца иллюзии
        self.mainAbility = self.ownerHero:FindAbilityByName("naga_siren_rip_tide_lua")
        self.mainModifier = self.ownerHero:FindModifierByName("modifier_naga_siren_rip_tide_lua")
        self.mainAbility.illusions[self:GetParent()] = true
    end
	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.stacks = self:GetAbility():GetSpecialValueFor( "stacks" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )

	

	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
    

	self.damageTable = {
		attacker = self.parent,
		damage = damage,
		damage_type = self.abilityDamageType,
		ability = self:GetAbility()
	}
end

function modifier_naga_siren_rip_tide_lua:OnDestroy( kv )
    if self.mainAbility then
        self.mainAbility.illusions[self:GetParent()] = nil
    end
end


modifier_naga_siren_rip_tide_lua.OnRefresh = modifier_naga_siren_rip_tide_lua.OnCreated

function modifier_naga_siren_rip_tide_lua:AddStack()
    self:SetStackCount( self:GetStackCount() + 1 )
    if self:GetStackCount() < self.stacks then return end
    self:SetStackCount( 0 )
    
    for illusion,_ in pairs(self.mainAbility.illusions) do
        if illusion:IsAlive() then
            illusion:FindModifierByName("modifier_naga_siren_rip_tide_lua"):PlayEffects()
        end
    end
    if self:GetParent():IsAlive() then
        self:PlayEffects()
    end
end

function modifier_naga_siren_rip_tide_lua:DeclareFunctions()
	return { MODIFIER_PROPERTY_PROCATTACK_FEEDBACK }
end

function modifier_naga_siren_rip_tide_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end
	if self.parent:PassivesDisabled() then return end
    local stacks = self.mainModifier:GetStackCount()
    self.mainModifier:AddStack()
	
end

function modifier_naga_siren_rip_tide_lua:PlayEffects()

    local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),
		self.parent:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			self.caster,
			self:GetAbility(),
			"modifier_naga_siren_rip_tide_lua_debuff",
			{ duration = self.duration }
		)
		self.damageTable.victim = enemy
        if self:GetParent():FindAbilityByName("npc_dota_hero_naga_siren_5") ~= nil and self:GetParent():FindAbilityByName("npc_dota_hero_naga_siren_5"):GetLevel() > 0 then
            self.damageTable.damage = self.abilityDamageType + 110
        end
		ApplyDamage( self.damageTable )
	end

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_siren/naga_siren_riptide.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		self.parent
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_NagaSiren.Riptide.Cast", self.parent )
end

modifier_naga_siren_rip_tide_lua_debuff = {}

function modifier_naga_siren_rip_tide_lua_debuff:IsHidden()
	return false
end

function modifier_naga_siren_rip_tide_lua_debuff:IsDebuff()
	return true
end

function modifier_naga_siren_rip_tide_lua_debuff:IsStunDebuff()
	return false
end

function modifier_naga_siren_rip_tide_lua_debuff:IsPurgable()
	return true
end

function modifier_naga_siren_rip_tide_lua_debuff:OnCreated( kv )
    self.armor = self:GetAbility():GetSpecialValueFor( "armor_reduction" )
    local talent = self:GetCaster():FindAbilityByName("npc_dota_hero_naga_siren_1")
    if talent and talent:GetLevel() > 0 then
        self.armor = self.armor + talent:GetSpecialValueFor("value")
    end
	
end

modifier_naga_siren_rip_tide_lua_debuff.OnRefresh = modifier_naga_siren_rip_tide_lua_debuff.OnCreated

function modifier_naga_siren_rip_tide_lua_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS }
end

function modifier_naga_siren_rip_tide_lua_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_naga_siren_rip_tide_lua_debuff:GetEffectName()
	return "particles/units/heroes/hero_siren/naga_siren_riptide_debuff.vpcf"
end

function modifier_naga_siren_rip_tide_lua_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end