LinkLuaModifier( "modifier_vengefulspirit_nether_swap_lua", "heroes/hero_vengefulspirit/vengefulspirit_nether_swap_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vengefulspirit_nether_swap_lua_effect", "heroes/hero_vengefulspirit/vengefulspirit_nether_swap_lua", LUA_MODIFIER_MOTION_NONE )

vengefulspirit_nether_swap_lua = class({})

function vengefulspirit_nether_swap_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function vengefulspirit_nether_swap_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hCaster == nil or hTarget == nil or hTarget:TriggerSpellAbsorb( this ) then
		return
	end

	local vPos2 = hTarget:GetOrigin()
	GridNav:DestroyTreesAroundPoint( vPos2, 300, false )
	
	hTarget:AddNewModifier( hCaster, self, "modifier_vengefulspirit_nether_swap_lua", { duration = 0.03 })
end
	
-------------------------------------------------	
	
modifier_vengefulspirit_nether_swap_lua = class({})

function modifier_vengefulspirit_nether_swap_lua:IsHidden()
	return true
end

function modifier_vengefulspirit_nether_swap_lua:IsPurgable()
	return false
end

function modifier_vengefulspirit_nether_swap_lua:OnCreated( kv )	
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local point = self:GetParent():GetOrigin()

	count = ability:GetSpecialValueFor("count")
	duration = ability:GetSpecialValueFor("duration")
	
	if caster:FindAbilityByName("npc_dota_hero_vengefulspirit_4")~=nil then
		if caster:FindAbilityByName("npc_dota_hero_vengefulspirit_4"):GetLevel() > 0 then 
			count = count + 1
		end
	end
	
	local illusions = CreateIllusions(caster, caster,
		{
			outgoing_damage = 0,
			incoming_damage = -100,
			duration = duration,
		}, -- hModiiferKeys
		count, -- nNumIllusions
		50, -- nPadding
		false, -- bScramblePosition
		true -- bFindClearSpace
	)

	for _, illusion in pairs(illusions) do
		FindClearSpaceForUnit(illusion, point + RandomVector( RandomInt(0, 100 )), false)
		illusion:AddNewModifier(caster, self, "modifier_vengefulspirit_nether_swap_lua_effect", {})
	end


	local nTargetFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_vengeful/vengeful_nether_swap_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
	ParticleManager:SetParticleControlEnt( nTargetFX, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nTargetFX )

	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", caster )
	EmitSoundOn( "Hero_VengefulSpirit.NetherSwap", self:GetParent() )

	caster:StartGesture( ACT_DOTA_CHANNEL_END_ABILITY_4 )
end

----------------------------------


local MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9 = 10001

modifier_vengefulspirit_nether_swap_lua_effect = class({})

function modifier_vengefulspirit_nether_swap_lua_effect:IsHidden()
	return true
end

function modifier_vengefulspirit_nether_swap_lua_effect:IsDebuff()
	return false
end

function modifier_vengefulspirit_nether_swap_lua_effect:IsPurgable()
	return false
end

function modifier_vengefulspirit_nether_swap_lua_effect:OnRefresh( kv )
	
end

function modifier_vengefulspirit_nether_swap_lua_effect:OnRemoved()
end

function modifier_vengefulspirit_nether_swap_lua_effect:OnDestroy()
end

function modifier_vengefulspirit_nether_swap_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
	return funcs
end

function modifier_vengefulspirit_nether_swap_lua_effect:GetModifierMoveSpeed_Absolute()
	return 550
end

function modifier_vengefulspirit_nether_swap_lua_effect:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}
	return state
end

function modifier_vengefulspirit_nether_swap_lua_effect:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_vengefulspirit_nether_swap_lua_effect:StatusEffectPriority()
	return MODIFIER_PRIORITY_MONKAGIGA_EXTEME_HYPER_ULTRA_REINFORCED_V9
end