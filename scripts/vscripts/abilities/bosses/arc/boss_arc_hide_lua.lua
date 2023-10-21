LinkLuaModifier("modifier_boss_arc_hide_lua_purge", "abilities/bosses/arc/boss_arc_hide_lua", LUA_MODIFIER_MOTION_NONE)

boss_arc_hide_lua = class({})

function boss_arc_hide_lua:OnSpellStart()
	local caster = self:GetCaster()
	local effectIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04_light_ufo.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( effectIndex , 0, caster:GetOrigin())
	Timers:CreateTimer(1, function()
			self:Start()
            ParticleManager:DestroyParticle(effectIndex,true)
            ParticleManager:ReleaseParticleIndex(effectIndex) 
        end)
	StartAnimation(caster, {duration = 2, activity = ACT_DOTA_CAST_ABILITY_1})
	caster:EmitSound("Hero_ArcWarden.Flux.Cast")
end

function boss_arc_hide_lua:Start()
	local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies > 0 then
		target = enemies[RandomInt(1, #enemies)]
		targetPoint = target:GetOrigin()
	else
		targetPoint = self:GetCaster():GetOrigin()
	end

	local ufoMoveIndex = ParticleManager:CreateParticle("particles/meteor_shadow.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( ufoMoveIndex , 0, targetPoint)
	AddFOWViewer( DOTA_TEAM_GOODGUYS, targetPoint, 700, 1.5, false)

	local time = 2.5
	caster:SetContextThink(DoUniqueString("OnNue04SpellThinkUfo"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			if time>0 then
				time = time - 0.05
			else
				ParticleManager:DestroyParticle(ufoMoveIndex,true)
				ParticleManager:ReleaseParticleIndex(ufoMoveIndex) 
				return nil
			end
			ParticleManager:SetParticleControl( ufoMoveIndex , 0, targetPoint - Vector(550,0,0) + (caster:GetOrigin() - targetPoint):Normalized()*time*100 )
			return 0.05
		end,
	0.05)

	caster:AddNoDraw()
	caster:AddNewModifier( caster, nil, "modifier_rooted", { duration = 2 } )
	caster:AddNewModifier( caster, nil, "modifier_disarmed", { duration = 2 } )
	FindClearSpaceForUnit(caster, targetPoint, false)
	caster:SetContextThink(DoUniqueString("OnNue04SpellThink"), 
		function()
			if GameRules:IsGamePaused() then return 0.03 end
			caster:RemoveNoDraw()
			local targets = FindUnitsInRadius(caster:GetTeam(), targetPoint, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
			local effectIndex = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl( effectIndex , 0, targetPoint)
			ParticleManager:SetParticleControl( effectIndex , 2, Vector(147,112,219))
			if caster:GetName() == "npc_dota_hero_phantom_assassin" then
				caster:EmitSound("Voice_Thdots_Nue.AbilityNue04_2")
			end

		    for k,v in pairs(targets) do
		    	local damage_table = {
				    victim = v,
				    attacker = caster,
				    damage = 3500,
				    damage_type = DAMAGE_TYPE_MAGICAL, 
				}
				v:AddNewModifier( caster, nil, "modifier_stunned", { duration = self:GetSpecialValueFor("duration")} )
				
		    	ApplyDamage(damage_table)
			end
			caster:StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
			local ufoIndex2 = ParticleManager:CreateParticle("particles/heroes/nue/ability_nue_04_light_ufo.vpcf", PATTACH_CUSTOMORIGIN, caster)
			Timers:CreateTimer(1, function()
				ParticleManager:DestroyParticle(ufoIndex2,true)
				ParticleManager:ReleaseParticleIndex(ufoIndex2) 
			end)

			caster:EmitSound("Hero_ArcWarden.SparkWraith.Damage")
			return nil
		end,
	2.5)
end