dado_tp_vixod = class({})

function dado_tp_vixod:OnSpellStart()
	local caster = self:GetCaster()
	local front = caster:GetForwardVector():Normalized()
	local target_pos = caster:GetOrigin() + front * 100
	
	EmitSoundOn("Hero_Enigma.Black_Hole.Stop", caster )
	if self.unit ~= nil then
		self.unit:ForceKill(false)
		UTIL_Remove( self.unit )
	end
	self.unit = CreateUnitByName("tp_out", target_pos, true, caster, nil, caster:GetTeamNumber())
end
