dado_ampl = class({})
LinkLuaModifier( "modifier_dado_ampl", "heroes/hero_dado/dado_ampl.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function dado_ampl:GetIntrinsicModifierName()
	return "modifier_dado_ampl"
end

-------------------------------------------------------------------------------

modifier_dado_ampl = class({})

--------------------------------------------------------------------------------

function modifier_dado_ampl:IsHidden()
	return false
end


function modifier_dado_ampl:IsPurgable()
    return false
end


function modifier_dado_ampl:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	ability = self:GetAbility()
	self.attack_spill = self:GetAbility():GetSpecialValueFor( "attack_spill" )
	self.attack_life = self:GetAbility():GetSpecialValueFor( "attack_life" )
	local field_fx = ParticleManager:CreateParticle("particles/dado_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	self:AddParticle(field_fx, false, false, -1, true, true)
end

function modifier_dado_ampl:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	ability = self:GetAbility()
	self.attack_spill = self:GetAbility():GetSpecialValueFor( "attack_spill" )
	self.attack_life = self:GetAbility():GetSpecialValueFor( "attack_life" )
end


function modifier_dado_ampl:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_dado_ampl:GetModifierSpellAmplify_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal3") ~= nil then 
		if self:GetCaster():FindAbilityByName("npc_dota_hero_dado_tal3"):GetLevel() > 0 then 
			return self.caster:GetIntellect() * self:GetAbility():GetSpecialValueFor( "attack_spill" ) + 0.2
		end
	end
	return self.caster:GetIntellect() * self:GetAbility():GetSpecialValueFor( "attack_spill" )
end

 hModifierAegis = 0;

function modifier_dado_ampl:OnTakeDamage( keys )
	if IsServer() then
	local parent = self:GetParent() 
	if self:GetParent():IsAlive() then
	
		local damage = keys.damage
		if parent ~= keys.unit then return end
		   
		if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
			return
		end
		hModifierAegis = hModifierAegis + 1
	
		if hModifierAegis >= self.attack_life then
		self.caster:SetHealth(self.caster:GetHealth()+damage)
		
		local field_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
		self:AddParticle(field_fx, false, false, -1, true, true)
		
		  Timers:CreateTimer({
			endTime = 1, 
			callback = function()
			ParticleManager:DestroyParticle( field_fx, false )
			end
		  })		
		hModifierAegis = 0;	
	end
	end
	end
end