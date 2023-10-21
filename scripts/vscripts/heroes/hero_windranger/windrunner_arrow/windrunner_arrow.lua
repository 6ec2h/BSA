windrunner_arrow = class({})

function windrunner_arrow:OnSpellStart()
    self:GetSpecialValue()
    local info = {
        EffectName = "particles/econ/items/windrunner/windrunner_weapon_sparrowhawk/windrunner_spell_powershot_sparrowhawk.vpcf",
        Ability = self,
        fStartRadius = 200,
        fEndRadius = 200,
        vVelocity = self:GetDirection() * 700,
        fDistance = 700,
        Source = self:GetCaster(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    }
    windrunner_arrow.delay = self.duration
    local count = self.duration * 5
	EmitSoundOn("Ability.Focusfire", self:GetCaster())
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("windrunner_arrow_think"), function ()
        if not self:GetCaster():IsAlive() then
            return nil
        end
        info.vSpawnOrigin = self:GetCaster():GetOrigin() + RandomVector(200)
        info.fExpireTime = GameRules:GetGameTime() + 2
        ProjectileManager:CreateLinearProjectile(info)
        count = count - 1
        if count <= 0 then
            return nil
        end
        return 0.2--0.1
    end, 0)
end

function windrunner_arrow:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil and not hTarget:IsMagicImmune() and not hTarget:IsInvulnerable() then
		ApplyDamage({
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.damage * self:GetCaster():GetIntellect() * 0.01,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		})
	end
	return false
end

function windrunner_arrow:GetSpecialValue()
    self.duration = self:GetSpecialValueFor("duration")
    self.scale = self:GetSpecialValueFor("scale")
    self.damage = self:GetSpecialValueFor("damage_int")
end

function windrunner_arrow:GetDirection()
    local cursor_pos = self:GetCursorPosition()
    local caster_pos = self:GetCaster():GetOrigin()
    if cursor_pos == caster_pos then
        cursor_pos = cursor_pos + RandomVector(1)
    end
	local direction = cursor_pos - caster_pos
	direction.z = 0.0
	return direction:Normalized()
end