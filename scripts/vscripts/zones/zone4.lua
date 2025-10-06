function quest_start(data)
	quest_system:StartQuest('main', 7, 'item_prison_cell_key')
end

function icespawn(iceq)
	cold_enabled(iceq.activator)

	random_ability = passive[RandomInt(1,#passive)]	
	local count = 0
	Timers:CreateTimer(0, function()
	if count < 22 then
		count = count + 1
		local point = Entities:FindByName( nil, "ice"..count):GetAbsOrigin()
		for i =1, 6 do
			if i == 1 then 
				local unit = CreateUnitByName("icespider", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
				rules:aura_dif(unit,random_ability)
			elseif i == 2 or i == 3 or i == 4 then
				local unit = CreateUnitByName("white_walker", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
				rules:aura_dif(unit,random_ability)
			elseif i == 5 then
				local unit = CreateUnitByName("mirana", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
				rules:aura_dif(unit,random_ability)
			else
				local unit = CreateUnitByName("npc_dota_creature_large_ogre_seal", point + RandomVector( RandomInt( 150, 150 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
				rules:aura_dif(unit,random_ability)	
			end	
		end
		return 0.1
	else
		return nil
		end
	end)

	if _G.Game_Difficulty >= 12 then
		Timers:CreateTimer(3, function()
			Notifications:TopToAll({text="#usilenie", duration=3})
			Notifications:TopToAll({text="#DOTA_Tooltip_ability_"..random_ability, duration=3})
		end)
	end
	
	rules:clear_zone('ice', 22)
end

function crate ( trigger )
	for i = 30, 40 do 
		local point = Entities:FindByName( nil, "crate"..i):GetAbsOrigin()
		 for i =1,RandomInt(3,4) do
			local unit = CreateUnitByName("npc_dota_crate", point + RandomVector( RandomInt( 50, 50 )), true, nil, nil, DOTA_TEAM_NEUTRALS)
		end
	end
end

function randomspawnkey(trigger)
	local hActivatorHero = trigger.activator
	if hActivatorHero ~= nil then
		local item = CreateItem("item_prison_cell_key", nil, nil)
		local pos = Entities:FindByName( nil, "rand"..RandomInt(1, 4)):GetAbsOrigin()
		local drop = CreateItemOnPositionSync( pos, item )
		local pos_launch = pos+RandomVector(RandomInt(10,10))
		-- item:LaunchLoot(false, 20, 0.75, pos_launch)
		item:LaunchLootInitialHeight( false, 0, 20, 0.5, pos_launch)
	end
end

------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------


cold_points = {
	[1] = {-15040, 117761, 300}, 
	[2] = {-14912, 13952, 300}, 
	[3] = {-15104, 7488, 300},
	[4] = {-13248, 10048, 300},
	[5] = {-9600, 10304, 300}}

campfires = {
	[1] = {-8486, 9976, 320},
	[2] = {-11922, 8528, 440},
	[3] = {-11436, 10822, 525},
	[4] = {-14515, 9369, 440},
	[5] = {-15520, 11208, 227},
	[6] = {-15153, 7282, 384},
	[7] = {-13476, 11356, 499},
	[8] = {-12004, 12033, 676},
	[9] = {-14735, 14716, 297},
	[10] = {-14840, 13399, 284},
	[11] = {-15618, 14041, 287}	
}

function cold_enabled(hero)
	for i = 1, 5 do
		pt = cold_points[i]
		local point = Vector(pt[1],pt[2],pt[3])
		CreateModifierThinker(hero, nil, "modifier_cold_aura", {radius = i}, point, DOTA_TEAM_NEUTRALS, false)
	end
	for i = 1, 11 do
		pt = campfires[i]
		local point = Vector(pt[1],pt[2],pt[3])
		CreateModifierThinker(hero, nil, "modifier_campfire_aura", {radius = i}, point, DOTA_TEAM_NEUTRALS, false)
	end
end

-----------------

modifier_campfire_aura = class({})

function modifier_campfire_aura:IsHidden()
	return false
end

function modifier_campfire_aura:IsPurgable()
	return false
end

function modifier_campfire_aura:IsAura()
	return true
end

function modifier_campfire_aura:OnCreated(data)  
	if data.radius then
		if data.radius == 1 then
			self.radius = 700
		elseif data.radius > 1 and data.radius < 6 then
			self.radius = 480
		else
			self.radius = 360
		end
	end
end

function modifier_campfire_aura:GetModifierAura()
	return "modifier_campfire_aura_effect"
end

function modifier_campfire_aura:GetAuraRadius()
	return self.radius
end

function modifier_campfire_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_campfire_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-----------------

modifier_campfire_aura_effect = class({})

function modifier_campfire_aura_effect:IsHidden()
	return false
end

function modifier_campfire_aura_effect:IsPurgable()
	return false
end

-----------------

modifier_cold_aura = class({})

function modifier_cold_aura:IsHidden()
	return true
end

function modifier_cold_aura:IsPurgable()
	return false
end

function modifier_cold_aura:IsAura()
	return true
end

function modifier_cold_aura:OnCreated(data)  
	if data.radius then
		if data.radius == 4 then
			self.radius = 6300/2
		elseif data.radius == 5 then
			self.radius = 4600/2
		else
			self.radius = 3400/2
		end
	end
end

function modifier_cold_aura:GetModifierAura()
	return "modifier_cold_map_ability"
end

function modifier_cold_aura:GetAuraRadius()
	return self.radius
end

function modifier_cold_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_cold_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

-----------------

modifier_cold_map_ability = class({})

function modifier_cold_map_ability:IsHidden() return false end
function modifier_cold_map_ability:IsDebuff() return true end
function modifier_cold_map_ability:IsPurgable()	return false end
function modifier_cold_map_ability:GetTexture() return "cold" end

function modifier_cold_map_ability:OnCreated( kv )  
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end

function modifier_cold_map_ability:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING,
    }
    return funcs
end

function modifier_cold_map_ability:GetDisableHealing()
	if self:GetParent():HasModifier("modifier_campfire_aura_effect") or self:GetParent():HasModifier("modifier_item_lich_heart") then return 0 end
    return 1
end

function modifier_cold_map_ability:OnIntervalThink()
    if IsServer() then
		if self:GetParent():HasModifier("modifier_campfire_aura_effect") or self:GetParent():HasModifier("modifier_item_lich_heart") then return end
        if self:GetParent():IsAlive() then
        local hAttacker = self:GetParent()
        local damageTable = {
            victim = self:GetParent(),
            attacker = hAttacker,
            damage = self:GetParent():GetMaxHealth() * 0.015,
            damage_type = DAMAGE_TYPE_PURE,
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        }
        ApplyDamage(damageTable)
        end
    end
end

function modifier_cold_map_ability:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_debuff.vpcf"
end

function modifier_cold_map_ability:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end
