require("data")
custom_sprout = class({})

creeps = {"npc_keeper_of_the_light", "miner", "small_hellbear", "encha", "treant"}

function custom_sprout:OnSpellStart()
	if not IsServer() then return end
	self.duration = self:GetSpecialValueFor( "duration" )
	self.radius = self:GetSpecialValueFor( "radius" )
	EmitSoundOn( "Hero_Furion.Sprout", self:GetCaster() )

	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_furion/furion_sprout.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 0.0, r, 0.0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	
	local random_ability = passive[RandomInt(1,#passive)]
	local line_pos = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * self.radius 
	local rotation_rate = 360 / 20
			
	for i = 1, 20 do
		line_pos = RotatePosition(self:GetCaster():GetAbsOrigin(), QAngle(0, rotation_rate, 0), line_pos)
		CreateTempTree(line_pos, self.duration)
		if i % 4 == 0 then
			local unit = CreateUnitByName(creeps[math.random(#creeps)], line_pos, true, nil, nil, DOTA_TEAM_NEUTRALS)
			unit:SetMaximumGoldBounty(0)
			unit:SetMinimumGoldBounty(0)
			unit:SetDeathXP(0)
			rules:aura_dif(unit,random_ability)
		end	
	end	
end