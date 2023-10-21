forest_quest_boom = class({})

LinkLuaModifier("modifier_forest_quest_boom", "abilities/creeps/forest_quest_boom", LUA_MODIFIER_MOTION_VERTICAL)

function forest_quest_boom:GetIntrinsicModifierName()
	return "modifier_forest_quest_boom"
end

------------------------------------------------------------------------------------------------------------------------------------------------------------
modifier_forest_quest_boom = class({})

function modifier_forest_quest_boom:IsHidden()
	return true
end

function modifier_forest_quest_boom:IsPurgable()
	return false
end

function modifier_forest_quest_boom:OnCreated( kv )
end

function modifier_forest_quest_boom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_forest_quest_boom:OnDeath(params)
if not IsServer() then return end
	if params.unit == self:GetParent() then
		
		self.damageTable = {
			attacker = self:GetCaster(),
			damage = 15000,
			damage_type = DAMAGE_TYPE_PURE,
		}

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs(enemies) do
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
		end
		
		EmitSoundOn("Hero_Techies.Suicide", self:GetCaster())

		local particle_explosion = "particles/units/heroes/hero_techies/techies_blast_off.vpcf"
		local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(particle_explosion_fx, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_explosion_fx)
	end
end