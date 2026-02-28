LinkLuaModifier( "modifier_circle_trap_lua_last_zone", "traps/traps_last_zone/circle_trap_lua_last_zone", LUA_MODIFIER_MOTION_NONE )

circle_trap_lua_last_zone = class({})

function circle_trap_lua_last_zone:GetIntrinsicModifierName()
	return "modifier_circle_trap_lua_last_zone"
end

---------------------------------------------------------------------------------------

modifier_circle_trap_lua_last_zone = class({})

function modifier_circle_trap_lua_last_zone:IsHidden()
	return true
end

function modifier_circle_trap_lua_last_zone:IsPurgable()
	return false
end

function modifier_circle_trap_lua_last_zone:OnCreated( kv )
	self.radius = 750
	self.points = 75 * RandomInt(-1,1)
	if self.points == 0 then
		self.points = 100
	end
	self.i = 0
	self:StartIntervalThink(0.03)
end

function modifier_circle_trap_lua_last_zone:OnIntervalThink()
if not IsServer() then return end

	if not _G.last_zone_traps_active then
		self:StartIntervalThink(-1)
	end

	b = self.i / self.points
	angle = 360 * b
	caster_pos = self:GetCaster():GetAbsOrigin()
	x = self.radius * math.sin(math.rad(angle)) + caster_pos.x
	y = self.radius * math.cos(math.rad(angle)) + caster_pos.y
	point = Vector(x, y, 0)
	local forwardVector = (point - caster_pos):Normalized()
	local info = {
		Ability = self:GetAbility(),
		EffectName = "particles/invoker_deafening_blast2.vpcf",
		vSpawnOrigin = caster_pos,
		fDistance = self.radius,
		fStartRadius = 40,			
		fEndRadius = 40,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		fExpireTime = GameRules:GetGameTime() + self.radius / 2500,
		bDeleteOnHit = false,
		vVelocity = Vector(forwardVector.x * 2000, forwardVector.y * 2000, 0),
	}
	ProjectileManager:CreateLinearProjectile( info )
	self.i = self.i + 1
end

function circle_trap_lua_last_zone:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = hTarget:GetMaxHealth(),
			damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage( damage )
		end
	return false
end