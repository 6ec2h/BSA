naga_siren_song_of_the_siren_cancel_lua = {}

function naga_siren_song_of_the_siren_cancel_lua:OnSpellStart()
	self.modifier:End()
	self.modifier = nil
end
