spectre_haunt_lua = class({})
LinkLuaModifier( "modifier_spectre_haunt_lua", "heroes/hero_spectre/spectre_haunt/modifier_spectre_haunt", LUA_MODIFIER_MOTION_NONE )

function spectre_haunt_lua:OnSpellStart()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor( "illusion_duration" )
	local outgoing = self:GetSpecialValueFor( "illusion_outgoing_damage" )
	local incoming = self:GetSpecialValueFor( "illusion_incoming_damage" )
	local distance = 72
	count = 1
	
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_spectre_4")
	if abil ~= nil and abil:GetLevel() > 0 then 
	count = 2
	end
	
	-- create illusion
	local illusions = CreateIllusions(
		self:GetCaster(), -- hOwner
		caster, -- hHeroToCopy
		{
			outgoing_damage = outgoing,
			incoming_damage = incoming,
			duration = duration,
		}, -- hModiiferKeys
		count, -- nNumIllusions
		distance, -- nPadding
		false, -- bScramblePosition
		true -- bFindClearSpace
	)
	
	
	Timers:CreateTimer(duration - 0.1, function()
	for i = 1, #illusions do
			local illusion = illusions[i]
			if illusion ~= nil then
			UTIL_Remove( illusion )
			end
		end
	end)
	
	local sound_cast = "Hero_Spectre.HauntCast"
		EmitSoundOn( sound_cast, illusion )
end



function RealityCast (keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local name = target:GetUnitName()
	
	if name == "npc_dota_hero_spectre" and target:IsIllusion() and target:IsAlive() then		
	local vPoint = target:GetOrigin() 

			local caster_forward_vector = caster:GetForwardVector()
			local target_forward_vector = target:GetForwardVector()

			--Swaps the forward vector of the caster and the illusion
			caster:SetForwardVector(target_forward_vector)
			target:SetForwardVector(caster_forward_vector)

			--Store the caster and the illusions current position
			local caster_current_position = caster:GetAbsOrigin()
			local target_current_position = target:GetAbsOrigin()

			--Swaps the position of the caster and the illusion
			target:SetAbsOrigin(caster_current_position)	
			caster:SetAbsOrigin(target_current_position)

			FindClearSpaceForUnit( caster, target_current_position, true )

			EmitSoundOn("Hero_Spectre.Reality", caster)

	end
end
