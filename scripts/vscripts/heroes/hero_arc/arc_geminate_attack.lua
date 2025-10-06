LinkLuaModifier("modifier_arc_geminate_attack", "heroes/hero_arc/arc_geminate_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arc_geminate_attack_delay", "heroes/hero_arc/arc_geminate_attack", LUA_MODIFIER_MOTION_NONE)

arc_geminate_attack					= class({})
modifier_arc_geminate_attack		= class({})
modifier_arc_geminate_attack_delay	= class({}) 

function arc_geminate_attack:GetBehavior()				return DOTA_ABILITY_BEHAVIOR_PASSIVE end
function arc_geminate_attack:GetIntrinsicModifierName()	return "modifier_arc_geminate_attack" end
function arc_geminate_attack:OnAbilityPhaseStart()		return false end


function modifier_arc_geminate_attack:IsHidden()	return true end

function modifier_arc_geminate_attack:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK}
end

function modifier_arc_geminate_attack:OnAttack(keys)
	if keys.attacker == self:GetParent() and self:GetAbility():IsFullyCastable() and not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() and not keys.no_attack_cooldown and keys.target:GetUnitName() ~= "npc_dota_observer_wards" and keys.target:GetUnitName() ~= "npc_dota_sentry_wards" then
	local how_much = self:GetAbility():GetSpecialValueFor("tooltip_attack")
	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_arc_warden_agi9")
	if abil ~= nil and abil:IsTrained() then 
	how_much = how_much + 1
	end
	
		for geminate_attacks = 1, how_much do
			self:GetParent():AddNewModifier(keys.target, self:GetAbility(), "modifier_arc_geminate_attack_delay", {delay = self:GetAbility():GetSpecialValueFor("delay") * geminate_attacks})
		end	
		self:GetAbility():UseResources( false,true, true, true )
	end
end


function modifier_arc_geminate_attack_delay:IsHidden()		return true end
function modifier_arc_geminate_attack_delay:IsPurgable()	return false end
function modifier_arc_geminate_attack_delay:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_arc_geminate_attack_delay:OnCreated(params)
	if not IsServer() then return end
	
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	
	local abil = self:GetParent():FindAbilityByName("special_bonus_arc_warden_str9")
	if abil ~= nil and abil:IsTrained() then
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage") * 2
	end
	
	if params and params.delay then
		self:StartIntervalThink(params.delay)
	end
end

function modifier_arc_geminate_attack_delay:OnIntervalThink()
	if self:GetParent():IsAlive() then
		self.attack_bonus = true
		self:GetParent():PerformAttack(self:GetCaster(), true, true, true, false, true, false, false) 
		self.attack_bonus = false
		
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

function modifier_arc_geminate_attack_delay:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_arc_geminate_attack_delay:GetModifierPreAttack_BonusDamage()
	if not IsServer() or not self.attack_bonus then return end

	return self.bonus_damage
end