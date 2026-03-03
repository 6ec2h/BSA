LinkLuaModifier("modifier_weaver_geminate_attack_custom", "heroes/hero_weaver/weaver_geminate_attack_custom/weaver_geminate_attack_custom", LUA_MODIFIER_MOTION_NONE)

weaver_geminate_attack_custom = class({})

function weaver_geminate_attack_custom:GetIntrinsicModifierName()
	return "modifier_weaver_geminate_attack_custom"
end

function weaver_geminate_attack_custom:OnUpgrade()
    if not IsServer() then return end
    if self and self:GetLevel() == 1 then
        self:ToggleAutoCast()
    end
end

modifier_weaver_geminate_attack_custom = class({})
function modifier_weaver_geminate_attack_custom:IsHidden() return true end
function modifier_weaver_geminate_attack_custom:IsPurgable() return false end
function modifier_weaver_geminate_attack_custom:IsPurgeException() return false end
function modifier_weaver_geminate_attack_custom:RemoveOnDeath() return false end
function modifier_weaver_geminate_attack_custom:OnCreated()
    if not IsServer() then return end
    self.double_attack = {}
end

function modifier_weaver_geminate_attack_custom:DeclareFunctions()
    return
    {
        MODIFIER_EVENT_ON_ATTACK,
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
    }
end

function modifier_weaver_geminate_attack_custom:GetModifierProcAttack_BonusDamage_Physical(params)
    if self.double_attack[params.record] ~= nil then
        local damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
        return damage
    end
end

function modifier_weaver_geminate_attack_custom:OnAttack(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.target == self:GetParent() then return end
	if params.no_attack_cooldown then
        self.double_attack[params.record] = true
        return 
    end
    if not self:GetAbility():GetAutoCastState() then return end
    if self:GetParent():PassivesDisabled() then return end
    local delay = self:GetAbility():GetSpecialValueFor("delay")
    if self:GetAbility():IsFullyCastable() then
        self:GetAbility():UseResources(false, false, false, true)
        for i=1, self:GetAbility():GetSpecialValueFor("tooltip_attack") do
            Timers:CreateTimer(delay*i, function()
                if params.target and not params.target:IsNull() and params.target:IsAlive() and not params.target:IsAttackImmune() and not params.target:IsInvulnerable() then
                    self:GetParent():PerformAttack(params.target, true, true, true, false, true, false, false) 
                end
            end)
        end
    end
end

function modifier_weaver_geminate_attack_custom:FastAttack(enemy)
    if not IsServer() then return end
    if enemy:IsAlive() and not enemy:IsAttackImmune() and not enemy:IsInvulnerable() then
        self:GetParent():PerformAttack(enemy, true, true, true, false, true, false, false)
    end
end