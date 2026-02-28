var ContainerHero = null
var visible_panel = false

function FixHeroIcons(){
    var list = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("GridCategories")
    var playerSlots = list.FindChildrenWithClassTraverse("HeroCard") 
	
	var tooltip = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().FindChildTraverse("ImageContainer")
	if (tooltip && (tooltip.GetChild(1).heroname == 'dado' || tooltip.GetChild(1).heroname == 'triss'|| tooltip.GetChild(1).heroname == 'destroyer'|| tooltip.GetChild(1).heroname == 'anakim')) {
		tooltip.GetChild(1).visible = false
		a = tooltip.GetChild(0)
		if (ContainerHero == null){
			ContainerHero = $.CreatePanel("DOTAHeroImage", tooltip, "image")
		}
		if (visible_panel == false){
			visible_panel = true
			ContainerHero.visible = visible_panel
			ContainerHero.SetImage( "file://{images}/custom_game/heroes/" + tooltip.GetChild(1).heroname + ".png" ) 
			ContainerHero.style.height = "256px" 
			ContainerHero.style.width = "193px" 
		}
	}else{
		if (ContainerHero&& visible_panel == true){
			visible_panel = false
			ContainerHero.visible = visible_panel
		}
	}
	
    for ( k in playerSlots ){
        var img = playerSlots[k].FindChildTraverse("HeroImage")
        if ( img.Children().length == 0 ){
			 if (img.heroname == 'dado' || img.heroname == 'triss'|| img.heroname == 'destroyer'|| img.heroname == 'anakim') {
				img.SetImage( "file://{images}/custom_game/heroes/" + img.heroname + ".png" ) 
				  
			 }			
        }
    }
    $.Schedule( 0.1, FixHeroIcons )
}

FixHeroIcons()