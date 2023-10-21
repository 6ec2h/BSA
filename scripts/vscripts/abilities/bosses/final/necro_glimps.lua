LinkLuaModifier("modifier_necro_glimps", "abilities/bosses/final/necro_glimps.lua", LUA_MODIFIER_MOTION_NONE)

necro_glimps = class({})

function necro_glimps:OnSpellStart()
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_necro_glimps",  { } )
end
----------------------------------------------------------------------------------

modifier_necro_glimps = class({})

function modifier_necro_glimps:IsHidden()
    return true
end

function modifier_necro_glimps:OnCreated()
if not IsServer() then return end
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,enemy in pairs(enemies) do
		local angle = RandomInt(0, 360)
		local variance = RandomInt(-1000, 1000)
		local dy = math.sin(angle) * variance
		local dx = math.cos(angle) * variance
		enemy.target_point = Vector(self:GetCaster():GetOrigin().x + dx, self:GetCaster():GetOrigin().y + dy, self:GetCaster():GetOrigin().z)
		self:BeginGlimpse(enemy, enemy.target_point)
		EmitSoundOn("Hero_Disruptor.Glimpse.Target", enemy)	
	end
end

function modifier_necro_glimps:BeginGlimpse(target, new_position)
	if IsServer() then				
		if target and new_position then
			local vVelocity = ( new_position - target:GetOrigin())
			vVelocity.z = 0.0

			local flDist = vVelocity:Length2D()
			vVelocity = vVelocity:Normalized()

			local flDuration = math.max(0.05, math.min(1.8, flDist / 600))
			local projectile =
			{
				Ability = self:GetAbility(),
				EffectName = "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf",
				vSpawnOrigin = target:GetOrigin(), 
				fDistance = flDist,
				Source = self:GetCaster(),                				
				vVelocity = vVelocity * ( flDist / flDuration ),
				fStartRadius = 0,
				fEndRadius = 0,				
				bProvidesVision = true,
				iVisionRadius = self.vision_radius,
				iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
			}			  

			ProjectileManager:CreateLinearProjectile(projectile)                      

			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_travel.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, new_position )
			ParticleManager:SetParticleControl( nFXIndex, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex, false, false, -1, false, false )

			local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetend.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 0, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex2, 1, new_position )
			ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex2, false, false, -1, false, false )

			local nFXIndex3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_disruptor/disruptor_glimpse_targetstart.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex3, 0, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex3, 2, Vector( flDuration, flDuration, flDuration ) )
			self:AddParticle( nFXIndex3, false, false, -1, false, false )
			
			EmitSoundOnLocationForAllies( new_position, "Hero_Disruptor.GlimpseNB2017.Destination", self:GetCaster() )
							
			self.time_glimps = flDuration
			
			Timers:CreateTimer(self.time_glimps, function()
				self:EndGlimpse(target, new_position)
			end)
		end		
	end
end


function modifier_necro_glimps:EndGlimpse(target, new_position)	
	if target and not target:IsMagicImmune() then
		FindClearSpaceForUnit( target, new_position, true)
		target:Interrupt()
		self:Destroy()		    	    		
	end
end
