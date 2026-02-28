function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model

	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end

	if caster.caster_model_scale == nil then 
		caster.caster_model_scale = caster:GetModelScale()
	end

	caster:SetOriginalModel(model)
	caster:SetModelScale(1.7)
end

function ModelSwapEnd( keys )
	local caster = keys.caster
	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetModelScale(caster.caster_model_scale)
	if caster:FindAbilityByName("npc_dota_hero_triss_tal4") ~= nil then 
		if caster:FindAbilityByName("npc_dota_hero_triss_tal4"):GetLevel() > 0 then 
			caster:AddNewModifier(caster, nil, "modifier_triss_bkb", {duration = 3})
		end
	end
end


-----------------------------------
LinkLuaModifier("modifier_triss_bkb", "heroes/hero_new/disguise.lua", LUA_MODIFIER_MOTION_NONE)

modifier_triss_bkb = class({})

function modifier_triss_bkb:IsHidden() return false end
function modifier_triss_bkb:IsPurgable() return false end
function modifier_triss_bkb:IsDebuff() return false end

function modifier_triss_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_triss_bkb:OnCreated()
	 EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetCaster())
end


function modifier_triss_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_triss_bkb:CheckState()
    local state = {[MODIFIER_STATE_MAGIC_IMMUNE] = true}

    return state
end

function modifier_triss_bkb:DeclareFunctions()
    local decFuncs = {MODIFIER_PROPERTY_MODEL_SCALE}
end

function modifier_triss_bkb:GetModifierModelScale()
    return 30
end
