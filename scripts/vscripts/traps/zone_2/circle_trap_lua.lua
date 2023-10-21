LinkLuaModifier( "modifier_circle_trap_lua", "traps/zone_2/circle_trap_lua", LUA_MODIFIER_MOTION_NONE )

circle_trap_lua = class({})

function circle_trap_lua:GetIntrinsicModifierName()
	return "modifier_circle_trap_lua"
end

---------------------------------------------------------------------------------------

modifier_circle_trap_lua = class({})

function modifier_circle_trap_lua:IsHidden()
	return true
end

function modifier_circle_trap_lua:IsPurgable()
	return false
end

circle_move = {2, -2.5, 3, -2, 2.5 -3}

function modifier_circle_trap_lua:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
	local ability = self
	local pathLength = 300
	local particleName = "particles/trap_sunray.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_WORLDORIGIN, nil )
	local attach_point = caster:ScriptLookupAttachment( "attach_head" )
	local deltaTime = 0.03
	
	self.speed = circle_move[RandomInt(1,#circle_move)]
	table.remove(circle_move, self.speed)

	caster:SetContextThink( DoUniqueString( "updateSunRay" ), function ( )
			local angle = caster:GetAngles()
			local new_angle = RotateOrientation(angle, QAngle(0,self.speed,0))
			caster:SetAngles(new_angle[1], new_angle[2], new_angle[3])
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
			
			if _G.All_traps_zone_2 == false then 
				ParticleManager:DestroyParticle( pfx, false )
				caster:ForceKill(false)
				return nil
			end

			local casterOrigin	= caster:GetAbsOrigin()
			local casterForward	= caster:GetForwardVector()

			local endcapPos = casterOrigin + casterForward * pathLength
			endcapPos = GetGroundPosition( endcapPos, nil )
			endcapPos.z = endcapPos.z + 92

			ParticleManager:SetParticleControl( pfx, 1, endcapPos )

			local units = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(), endcapPos, nil, 50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
			for _,unit in pairs(units) do
				local damageTable = {
					victim = unit,
					attacker = self:GetCaster(),
					damage = unit:GetMaxHealth(),
					damage_type = DAMAGE_TYPE_PURE
				}
				ApplyDamage(damageTable)
			end
		return deltaTime
	end, 0.0 )
end	
 










