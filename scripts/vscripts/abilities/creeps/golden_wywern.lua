LinkLuaModifier("modifier_golden_splinter_blast_colba", "abilities/creeps/golden_wywern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golden_splinter_blast_splinter_charge", "abilities/creeps/golden_wywern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golden_touch", "abilities/creeps/golden_wywern.lua", LUA_MODIFIER_MOTION_NONE)


golden_splinter_blast = class({});

function golden_splinter_blast:OnSpellStart() 
	if IsServer() then
		local caster 						= self:GetCaster();
		local target 						= self:GetCursorTarget();
		local secondary_projectile_speed 	= self:GetSpecialValueFor("secondary_projectile_speed");
		local split_radius 					= self:GetSpecialValueFor("split_radius");
		local slow_duration 				= self:GetSpecialValueFor("duration");
		local speed							= self:GetSpecialValueFor("projectile_speed")
		local damage						= self:GetSpecialValueFor("damage")

		caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Cast");

		golden_splinter_blast:CreateTrackingProjectile(
		{
			target 						= target,
			caster 						= caster,
			ability 					= self,
			iMoveSpeed 					= speed,
			iSourceAttachment 			= self:GetCaster():ScriptLookupAttachment("attach_attack1"),
			EffectName 					= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter.vpcf",
			secondary_projectile_speed 	= secondary_projectile_speed,
			split_radius 				= split_radius,
			slow_duration 				= slow_duration,
			slow						= slow,
			attack_slow 				= attack_slow,
			hero_cdr 					= hero_cdr,
			cdr_units 					= cdr_units,
			splinter_threshold 			= splinter_threshold,
			splinter_dmg_efficiency 	= splinter_dmg_efficiency,
			splinter_aoe_efficiency 	= splinter_aoe_efficiency,
			damage 						= damage,
			splinter_proc 				= 0
		});	
	end
end

function golden_splinter_blast:CreateTrackingProjectile(keys)
    local target = keys.target;
    local caster = keys.caster;
    local speed = keys.iMoveSpeed;
 
    keys.creation_time = GameRules:GetGameTime();

    local projectile = caster:GetAttachmentOrigin(keys.iSourceAttachment);
 
    local particle = ParticleManager:CreateParticle(keys.EffectName, PATTACH_POINT, caster);

    caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Projectile");

    local arctic_flight_offset = Vector(0,0,0);
    if caster:HasModifier("modifier_winter_wyvern_arctic_burn_flight") then 
    	arctic_flight_offset = Vector(0,0, 150);
    end

    ParticleManager:SetParticleControl(particle, 0, caster:GetAttachmentOrigin(keys.iSourceAttachment) + arctic_flight_offset);
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true);
    ParticleManager:SetParticleControl(particle, 2, Vector(speed, 0, 0));
 
    Timers:CreateTimer(function()
        local target_location = target:GetAbsOrigin();
 
        projectile = projectile + (target_location - projectile):Normalized() * speed * FrameTime();
 
        if (target_location - projectile):Length2D() < speed * FrameTime() then
            golden_splinter_blast:OnTrackingProjectileHit(keys);
            caster:StopSound("Hero_Winter_Wyvern.SplinterBlast.Projectile");
            ParticleManager:DestroyParticle(particle, false);
            ParticleManager:ReleaseParticleIndex(particle);
 
            return nil
        else
        	speed = speed + 25;
			ParticleManager:SetParticleControl(particle, 2, Vector(speed, 0, 0));

            return 0
        end
    end)
end

function golden_splinter_blast:OnTrackingProjectileHit(keys)

	keys.target:AddNewModifier(keys.caster, keys.self, "modifier_silence", {duration = keys.slow_duration * (1 - keys.target:GetStatusResistance())});

	local nearby_enemy_units = FindUnitsInRadius(
		keys.caster:GetTeam(),
		keys.target:GetAbsOrigin(), 
		nil, 
		keys.split_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	);

	keys.caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Target");

	for _,enemy in pairs(nearby_enemy_units) do 
		if enemy ~= keys.target and enemy:IsAlive() then
			local extra_data = {
				damage 						= keys.damage, 
				slow_duration 				= keys.slow_duration, 
				slow 						= keys.slow, 
				attack_slow 				= keys.attack_slow, 
				hero_cdr 					= keys.hero_cdr, 
				cdr_units 					= keys.cdr_units, 
				split_radius 				= keys.split_radius, 
				splinter_threshold 			= keys.splinter_threshold, 
				secondary_projectile_speed 	= keys.secondary_projectile_speed,
				splinter_dmg_efficiency 	= keys.splinter_dmg_efficiency,
				splinter_aoe_efficiency 	= keys.splinter_aoe_efficiency,
				splinter_proc 			   	= keys.splinter_proc
			}

			local projectile =
			{
				Target 				= enemy,
				Source 				= keys.target,
				Ability 			= keys.ability,
				EffectName 			= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
				iMoveSpeed			= keys.secondary_projectile_speed,
				vSourceLoc 			= keys.target:GetAbsOrigin(),
				bDrawsOnMinimap 	= false,
				bDodgeable 			= true,
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 10,
				bProvidesVision 	= true,
				iVisionRadius 		= 400,
				iVisionTeamNumber 	= keys.caster:GetTeamNumber(),
				ExtraData = extra_data
			}

			ProjectileManager:CreateTrackingProjectile(projectile);
		end
		
	end
end

function golden_splinter_blast:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target and target:IsAlive() and not target:HasModifier("modifier_silence") then 
		local caster = self:GetCaster();
		if ExtraData.splinter_proc == 0 then 
			local splinter_proj = {
				caster 						= caster,
				target 						= target,
				ability 					= self,
				damage 						= ExtraData.damage, 
				slow_duration 				= ExtraData.slow_duration, 
				slow 						= ExtraData.slow, 
				attack_slow 				= ExtraData.attack_slow, 
				hero_cdr 					= ExtraData.hero_cdr, 
				cdr_units 					= ExtraData.cdr_units, 
				split_radius 				= ExtraData.split_radius, 
				splinter_threshold 			= ExtraData.splinter_threshold, 
				secondary_projectile_speed 	= ExtraData.secondary_projectile_speed,
				splinter_dmg_efficiency  	= ExtraData.splinter_dmg_efficiency,
				splinter_aoe_efficiency 	= ExtraData.splinter_aoe_efficiency,
				splinter_proc 			   	= ExtraData.splinter_proc + 1
			}
			
			golden_splinter_blast:OnTrackingProjectileHit(splinter_proj);
		end

		target:AddNewModifier(caster, self, "modifier_golden_splinter_blast_colba", {duration = ExtraData.slow_duration * (1 - target:GetStatusResistance())});
		
		caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Splinter");

		local damage_table 			= {};
		damage_table.attacker 		= caster;
		damage_table.ability 		= self;
		damage_table.damage_type 	= self:GetAbilityDamageType();
		damage_table.damage	 		= ExtraData.damage;
		damage_table.victim  		= target;
		ApplyDamage(damage_table)
	end
end

--------------------------------------------------------------

modifier_golden_splinter_blast_colba = class({})

function modifier_golden_splinter_blast_colba:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end

function modifier_golden_splinter_blast_colba:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_golden_splinter_blast_colba:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

golden_touch = class({})
modifier_golden_touch = class({})

function golden_touch:GetIntrinsicModifierName()
	return "modifier_golden_touch"
end

function modifier_golden_touch:DeclareFunctions()
	return {
      	MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
end

function modifier_golden_touch:OnAttackLanded( keys )
	if keys.attacker == self:GetParent() then
	if keys.target:IsMagicImmune() then return end

	keys.target:EmitSound("Hero_Ancient_Apparition.ChillingTouch.Target")
	
	ApplyDamage({
		victim 			= keys.target,
		damage 			= self:GetAbility():GetSpecialValueFor("damage"),
		damage_type		= DAMAGE_TYPE_PURE,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self
	})
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, keys.target, self:GetAbility():GetSpecialValueFor("damage"), nil)
	end
end