LinkLuaModifier( "modifier_naga_siren_ensnare_lua", "heroes/hero_naga/naga_siren_ensnare_lua/naga_siren_ensnare_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "naga_sirenmodifier_naga_siren_ensnare_luamirror_image", "heroes/hero_naga/naga_siren_ensnare_lua/naga_siren_ensnare_lua", LUA_MODIFIER_MOTION_NONE )

naga_siren_ensnare_lua = {}

function naga_siren_ensnare_lua:OnAbilityPhaseStart()
	-- local caster = self:GetCaster()
	-- local fake_radius = self:GetSpecialValueFor( "fake_ensnare_distance" )
	-- local illusions = FindUnitsInRadius(
	-- 	caster:GetTeamNumber(),
	-- 	caster:GetOrigin(),
	-- 	nil,
	-- 	fake_radius,
	-- 	DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	-- 	DOTA_UNIT_TARGET_HERO,
	-- 	0,
	-- 	0,
	-- 	false
	-- )

	-- local playerID = caster:GetPlayerOwnerID()
	-- local model = caster:GetModelName()
	-- for _,illusion in pairs(illusions) do
	-- 	if illusion:GetPlayerOwnerID()==playerID and illusion:IsIllusion() and illusion:GetModelName()==model then
	-- 		illusion:StartGesture( ACT_DOTA_CAST_ABILITY_2 )

	-- 		self.illusions[illusion] = true
	-- 	end
	-- end

	return true
end

function naga_siren_ensnare_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function naga_siren_ensnare_lua:OnAbilityPhaseInterrupted()
	self.illusions = {}
end

naga_siren_ensnare_lua.illusions = {}

function naga_siren_ensnare_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target_point = self:GetCursorPosition()
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), target_point, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for i = 1, #targets do
        local info = {
            Target = targets[i],
            Source = caster,
            Ability = self,
            EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
            iMoveSpeed = self:GetSpecialValueFor( "net_speed" ),
            bDodgeable = true,
            ExtraData = {
                fake = 0,
            }
        }
        ProjectileManager:CreateTrackingProjectile(info)
		-- for illusion,_ in pairs(self.illusions) do
		-- 	info.Source = illusion
		-- 	info.ExtraData = {
		-- 		fake = 1
		-- 	}
		-- 	ProjectileManager:CreateTrackingProjectile(info)
		-- end
    end

	
	-- for illusion,_ in pairs(self.illusions) do
	-- 	EmitSoundOn( "Hero_NagaSiren.Ensnare.Cast", illusion )
	-- end

	self.illusions = {}

	EmitSoundOn( "Hero_NagaSiren.Ensnare.Cast", caster )
end

function naga_siren_ensnare_lua:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end
	if data.fake==1 then return end
	if target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	local duration = self:GetSpecialValueFor( "duration" )

	target:AddNewModifier(
		self:GetCaster(),
		self,
		"naga_sirenmodifier_naga_siren_ensnare_luamirror_image",
		{ duration = duration }
	)
	
	local info = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetSpecialValueFor("damage"),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	local talent = self:GetCaster():FindAbilityByName("special_bonus_naga_siren_2")
	if talent and talent:GetLevel() > 0 then
		info.damage = info.damage + talent:GetSpecialValueFor("value")
	end
	ApplyDamage(info)
	EmitSoundOn( "Hero_NagaSiren.Ensnare.Target", target )
end

naga_sirenmodifier_naga_siren_ensnare_luamirror_image = {}

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:IsHidden()
	return false
end

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:IsDebuff()
	return true
end

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:IsStunDebuff()
	return false
end

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:IsPurgable()
	return true
end

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true
	}
end

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:GetEffectName()
	return "particles/units/heroes/hero_siren/siren_net.vpcf"
end

function naga_sirenmodifier_naga_siren_ensnare_luamirror_image:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end