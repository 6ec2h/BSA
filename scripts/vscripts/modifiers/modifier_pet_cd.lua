modifier_pet_cd = class({})

function modifier_pet_cd:IsHidden()
    return false
end

function modifier_pet_cd:IsPurgable()
    return false
end

function modifier_pet_cd:RemoveOnDeath()
    return false
end
