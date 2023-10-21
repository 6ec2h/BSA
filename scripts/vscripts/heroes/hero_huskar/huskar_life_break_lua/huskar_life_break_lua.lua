LinkLuaModifier( "modifier_huskar_life_break_lua", "heroes/hero_huskar/huskar_life_break_lua/huskar_life_break_lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_huskar_life_break_lua_debuff", "heroes/hero_huskar/huskar_life_break_lua/huskar_life_break_lua", LUA_MODIFIER_MOTION_NONE )

huskar_life_break_lua = class({})

function huskar_life_break_lua:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_huskar_life_break_lua", {target = self:GetCursorTarget():GetEntityIndex()})
	EmitSoundOn(  "Hero_Huskar.Life_Break", caster )
end

----------------------------------------------------------------

modifier_huskar_life_break_lua = class({})

function modifier_huskar_life_break_lua:IsHidden()
	return false
end

function modifier_huskar_life_break_lua:IsDebuff()
	return false
end

function modifier_huskar_life_break_lua:IsStunDebuff()
	return false
end

function modifier_huskar_life_break_lua:IsPurgable()
	return false
end

function modifier_huskar_life_break_lua:OnCreated(data)
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.damage_pct = self:GetAbility():GetSpecialValueFor( "health_damage" )
	self.duraiton = self:GetAbility():GetSpecialValueFor( "duraiton" )
	self.close_distance = 80
	self.far_distance = 1450
	
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_tal_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.damage_pct = self.damage_pct + 25
	end
	
	if IsServer() then
		self.target = EntIndexToHScript(data.target)
		self:GetParent():Purge( false, true, false, false, false )
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_huskar_life_break_lua:OnRefresh( kv )
end

function modifier_huskar_life_break_lua:OnRemoved()
end

function modifier_huskar_life_break_lua:OnDestroy()
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
		if not self.success then return end
		
		local damage = self.damage_pct * self:GetCaster():GetHealth() / 100
		
		local damageTable = {
			victim = self.target,
			attacker = self:GetCaster(),
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(),
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}
		ApplyDamage(damageTable)
		damageTable.victim = self:GetCaster()
		damageTable.damage = damage
		damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		
		ApplyDamage(damageTable)

		self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_huskar_life_break_lua_debuff", { duration = self.duraiton })
		self:PlayEffects()
	end
end

function modifier_huskar_life_break_lua:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function modifier_huskar_life_break_lua:UpdateHorizontalMotion( me, dt )
	local origin = self:GetParent():GetOrigin()

	if not self.target:IsAlive() then
		self:EndCharge( false )
	end

	local direction = self.target:GetOrigin() - origin
	direction.z = 0
	local distance = direction:Length2D()
	direction = direction:Normalized()

	if distance<self.close_distance then
		self:EndCharge( true )
	elseif distance>self.far_distance then
		self:EndCharge( false )
	end

	local target = origin + direction * self.speed * dt
	self:GetParent():SetOrigin( target )
	self:GetParent():FaceTowards( self.target:GetOrigin() )
end

function modifier_huskar_life_break_lua:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_huskar_life_break_lua:EndCharge( success )
	if success and (not self.target:TriggerSpellAbsorb(self:GetAbility())) then
		self.success = true
	end
	self:Destroy()
end


function modifier_huskar_life_break_lua:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( "Hero_Huskar.Life_Break.Impact", self.target )
end


----------------------------------------------------------------------------------------

modifier_huskar_life_break_lua_debuff = class({})

function modifier_huskar_life_break_lua_debuff:IsHidden()
	return false
end

function modifier_huskar_life_break_lua_debuff:IsDebuff()
	return true
end

function modifier_huskar_life_break_lua_debuff:IsStunDebuff()
	return false
end

function modifier_huskar_life_break_lua_debuff:IsPurgable()
	return true
end

function modifier_huskar_life_break_lua_debuff:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "movespeed" )
	local ability = self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_tal_3")
	if ability ~= nil and ability:GetLevel() > 0 then 
		self.slow = self.slow + 25
	end
end

function modifier_huskar_life_break_lua_debuff:OnRefresh( kv )
	
end

function modifier_huskar_life_break_lua_debuff:OnRemoved()
end

function modifier_huskar_life_break_lua_debuff:OnDestroy()
end

function modifier_huskar_life_break_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_huskar_life_break_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow*(-1)
end

function modifier_huskar_life_break_lua_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end