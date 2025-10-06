local THIS_LUA = "heroes/hero_windranger/windrunner_powershot_lua/windrunner_powershot_lua.lua"
LinkLuaModifier("modifier_debuff_resist", "heroes/hero_windranger/windrunner_powershot_lua/windrunner_powershot_lua", LUA_MODIFIER_MOTION_NONE)

windrunner_powershot_lua = class({})

if IsServer() then
	function windrunner_powershot_lua:OnSpellStart( )
		local ability = self
		local caster = self:GetCaster()
		local pos = self:GetCursorPosition()
		local direction = CalculateDirection(pos, caster:GetAbsOrigin())
		self.damage = 0


		local caster = self:GetCaster()
		EmitSoundOn("Ability.Powershot", caster)

		caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
		local distance = self:GetSpecialValueFor("arrow_range")
		local p_name = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
		
		
		local talent = self:GetCaster():FindAbilityByName("special_bonus_windrunner_int11")
		if talent ~= nil and talent:GetLevel() > 0 then 
			local direction_1 = RotatePosition(Vector(0,0,0), QAngle(0,10,0), caster:GetForwardVector())
			local direction_11 = RotatePosition(Vector(0,0,0), QAngle(0,350,0), caster:GetForwardVector())
			
			
			self:FireLinearProjectile(
			p_name, 
			direction_1 * self:GetSpecialValueFor("arrow_speed"),
			distance,
			self:GetSpecialValueFor("arrow_width"), 
			{ExtraData={ damage = self.damage }},
			false,
			true, 
			self:GetSpecialValueFor("vision_radius"))
			
			
			
			self:FireLinearProjectile(p_name, direction_11 * self:GetSpecialValueFor("arrow_speed"), distance, self:GetSpecialValueFor("arrow_width"), 
			{ExtraData={ damage = self.damage }}, false, true, self:GetSpecialValueFor("vision_radius"))
		else
			self:FireLinearProjectile(p_name, caster:GetForwardVector() * self:GetSpecialValueFor("arrow_speed"), distance, self:GetSpecialValueFor("arrow_width"), 
			{ExtraData={ damage = self.damage }}, false, true, self:GetSpecialValueFor("vision_radius"))
		end
	end
end

function windrunner_powershot_lua:OnProjectileHit(hTarget, vLocation)
	if not IsServer() then return end
	local ability = self
	local caster = self:GetCaster()

	if hTarget then 
		EmitSoundOn("Ability.PowershotDamage", hTarget)

		local damage = GetTalentSpecialValueFor(ability, "attack_damage")	
		         
		if self:GetCaster():FindAbilityByName("special_bonus_windrunner_int6")~=nil then
			if self:GetCaster():FindAbilityByName("special_bonus_windrunner_int6"):GetLevel() > 0 then 
				hTarget:AddNewModifier(caster, ability, "modifier_debuff_resist", {duration = 2})
			end
		end
		
		ApplyDamage({
			victim = hTarget, attacker = caster, 
			ability = ability, damage_type = ability:GetAbilityDamageType(), 
			damage = damage, damage_flags = DOTA_DAMAGE_FLAG_NONE
		})
	else
		AddFOWViewer(caster:GetTeam(), vLocation, ability:GetSpecialValueFor("vision_radius"), ability:GetSpecialValueFor("vision_duration"), true)
	end
end

function windrunner_powershot_lua:OnProjectileThink(vLocation)
	if not IsServer() then return end
	GridNav:DestroyTreesAroundPoint(vLocation, self:GetSpecialValueFor("arrow_width"), true)
end


function windrunner_powershot_lua:FireLinearProjectile(FX, velocity, distance, width, data, bDelete, bVision, vision)
	local internalData = data or {}
	local delete = false
	if bDelete then delete = bDelete end
	local provideVision = true
	if bVision then provideVision = bVision end
	local info = {
		EffectName = FX,
		Ability = self,
		vSpawnOrigin = internalData.origin or self:GetCaster():GetAbsOrigin(), 
		fStartRadius = width,
		fEndRadius = internalData.width_end or width,
		vVelocity = velocity,
		fDistance = distance or 1000,
		Source = internalData.source or self:GetCaster(),
		iUnitTargetTeam = internalData.team or self:GetAbilityTargetTeam(),
		iUnitTargetType = internalData.type or self:GetAbilityTargetType(),
		iUnitTargetFlags = internalData.type or self:GetAbilityTargetFlags(),
		iSourceAttachment = internalData.attach or DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bDeleteOnHit = delete,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		bProvidesVision = provideVision,
		iVisionRadius = vision or 100,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData = internalData.extraData
	}
	local projectile = ProjectileManager:CreateLinearProjectile( info )
	return projectile
end


-----------------------------------------------------------------------------------------

function CalculateDirection(ent1, ent2)
	local pos1 = ent1
	local pos2 = ent2
	if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
	if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
	local direction = (pos1 - pos2):Normalized()
	direction.z = 0
	return direction
end


function HasTalent(unit, talentName)
    if unit:HasAbility(talentName) then
        if unit:FindAbilityByName(talentName):GetLevel() > 0 then return true end
    end
    return false
end

function GetTalentSpecialValueFor(ability, value)
    local base = ability:GetSpecialValueFor(value)
    local talentName
    local kv = ability:GetAbilityKeyValues()
    for k,v in pairs(kv) do -- trawl through keyvalues
        if k == "AbilitySpecial" then
            for l,m in pairs(v) do
                if m[value] then
                    talentName = m["LinkedSpecialBonus"]
                end
            end
        end
    end
    if talentName then 
        local talent = ability:GetCaster():FindAbilityByName(talentName)
        if talent and talent:GetLevel() > 0 then base = base + talent:GetSpecialValueFor("value") end
    end
    return base
end

function RotateVector2D(v,theta)
    local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
    local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
    return Vector(xp,yp,v.z):Normalized()
end


--------------------------------
--------------------------------
--------------------------------

modifier_debuff_resist = class({})

function modifier_debuff_resist:IsHidden()
	return true
end

function modifier_debuff_resist:IsDebuff()
	return false
end

function modifier_debuff_resist:IsPurgable()
	return false
end

function modifier_debuff_resist:OnCreated( kv )

end

function modifier_debuff_resist:OnRefresh( kv )

end

function modifier_debuff_resist:OnIntervalThink()

end


function modifier_debuff_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_debuff_resist:GetModifierMagicalResistanceBonus()
	return -15
end