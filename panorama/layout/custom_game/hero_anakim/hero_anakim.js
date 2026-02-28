$("#hero_anakim_container").visible = false

function Anakim_show(t) {
	$.Msg("D")
    $("#hero_anakim_container").visible = true
}

function Anakim_hide(t) {
	$.Msg("Da")
    $("#hero_anakim_container").visible = false
}

GameEvents.Subscribe("Anakim_show", Anakim_show);
GameEvents.Subscribe("Anakim_hide", Anakim_hide);