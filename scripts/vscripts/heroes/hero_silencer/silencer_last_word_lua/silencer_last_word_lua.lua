silencer_last_word_lua = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "heroes/generic/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_silencer_last_word_lua", "heroes/hero_silencer/silencer_last_word_lua/modifier_silencer_last_word_lua", LUA_MODIFIER_MOTION_NONE )


function silencer_last_word_lua:GetAOERadius()
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int3")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		return self:GetSpecialValueFor("radius")
	end
	return 0
end

function silencer_last_word_lua:GetBehavior()
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int3")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		return  DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
	end

	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function silencer_last_word_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "debuff_duration" )
	
	local talent_ability = self:GetCaster():FindAbilityByName("npc_dota_hero_silencer_int3")
		if talent_ability ~= nil and talent_ability:GetLevel() > 0 then
		local radius = self:GetSpecialValueFor("radius")
		local target_point = self:GetCursorPosition()
		local units = FindUnitsInRadius(caster:GetTeamNumber(),target_point,nil,radius,	DOTA_UNIT_TARGET_TEAM_ENEMY,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_NONE,	FIND_ANY_ORDER,	false)
			for _,unit in pairs(units) do
				unit:AddNewModifier(caster, self,"modifier_silencer_last_word_lua", { duration = duration } )
				self:PlayEffects( unit )
			end			
		else
		local target = self:GetCursorTarget()
		target:AddNewModifier(caster, self,"modifier_silencer_last_word_lua", { duration = duration } )
		self:PlayEffects( target )
	end
end

--------------------------------------------------------------------------------
function silencer_last_word_lua:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_silencer/silencer_last_word_status_cast.vpcf"
	local sound_cast = "Hero_Silencer.LastWord.Cast"

	-- Get Data
	local direction = target:GetOrigin()-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end