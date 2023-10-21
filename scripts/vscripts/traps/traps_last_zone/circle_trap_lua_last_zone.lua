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

circle_move_last = {2, -2.25, 2.75, -2.75, -2.5, 3, -2, 2.5, 2.25, -3}

function modifier_circle_trap_lua_last_zone:OnCreated( kv )
if not IsServer() then return end
	local caster = self:GetCaster()
	local pathLength = 400
	local pfx = ParticleManager:CreateParticle( "particles/trap_sunray.vpcf", PATTACH_WORLDORIGIN, nil )
	local attach_point = caster:ScriptLookupAttachment( "attach_head" )
	local deltaTime = 0.03
	
	self.speed = circle_move_last[RandomInt(1,#circle_move_last)]
	table.remove(circle_move_last, self.speed)

	caster:SetContextThink( DoUniqueString( "updateSunRay" ), function ( )
			local angle = caster:GetAngles()
			local new_angle = RotateOrientation(angle, QAngle(0,self.speed,0))
			caster:SetAngles(new_angle[1], new_angle[2], new_angle[3])
			ParticleManager:SetParticleControl(pfx, 0, caster:GetAttachmentOrigin(attach_point))
			
			if not _G.last_zone_circle_traps_active then
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
				if unit ~= nil and ( not unit:IsMagicImmune() ) and ( not unit:IsInvulnerable() ) then
					local damageTable = {
						victim = unit,
						attacker = self:GetCaster(),
						damage = unit:GetMaxHealth(),
						damage_type = DAMAGE_TYPE_PURE
					}
					ApplyDamage(damageTable)
				end
			end
		return deltaTime
	end, 0.0 )
end

function OffCircleTraps(trigger)
	local triggerName = thisEntity:GetName()
	local button = triggerName .. "_button"
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down", 0, self, self )
	DoEntFire( button, "SetAnimation", "ancient_trigger001_down_idle", .35, self, self )
	_G.last_zone_circle_traps_active = false
end