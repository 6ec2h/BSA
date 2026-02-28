modifier_no_heal = class({})

function modifier_no_heal:IsHidden()
    return false
end

function modifier_no_heal:RemoveOnDeath()
    return false
end

function modifier_no_heal:IsPurgable()
    return false
end

function modifier_no_heal:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_HEALING,
    }
    return funcs
end

function modifier_no_heal:GetDisableHealing()
    return 1
end