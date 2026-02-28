modifier_guild_event = class({})

function modifier_guild_event:IsHidden()
    return false
end

function modifier_guild_event:IsPurgable()
    return false
end

function modifier_guild_event:IsPurgeException()
    return false
end

function modifier_guild_event:RemoveOnDeath()
    return false
end