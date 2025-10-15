var position = {
    'd1': { x: 13, y: 13 },
    'd2': { x: 29, y: 6 },
    'd3': { x: 42, y: 8 },
    'd4': { x: 49, y: 18 },
    'd5': { x: 59, y: 19 },
    'd6': { x: 66, y: 10 },
    'd7': { x: 78, y: 17 },
    'd8': { x: 90, y: 26 },
    'd9': { x: 92, y: 42 },
    'd10': { x: 89, y: 58 },
    'd11': { x: 77, y: 49 },
    'd12': { x: 88, y: 73 },
    'd13': { x: 78, y: 82 },
    'd14': { x: 65, y: 84 },
    'd15': { x: 61, y: 56 },
    'd16': { x: 41, y: 43 },
    'd17': { x: 23, y: 26 },
    'd18': { x: 8, y: 49 },
    'd19': { x: 18, y: 56 },
    'd20': { x: 29, y: 65 },
};

var mainPanel = $.GetContextPanel().FindChildTraverse("Diff_container");

i = 0;

for (let key in position) {
    if (position.hasOwnProperty(key)) {
        i++;
        ((i) => {
            let panel = $.CreatePanel('Panel', mainPanel, key);
            panel.AddClass('all_d');

            let innerPanel = $.CreatePanel('Panel', panel, 'Diff_' + i);
            innerPanel.AddClass('dif_icon');
            innerPanel.AddClass('lock');

            // innerPanel.SetPanelEvent('onmouseover', function() {
                // TipsCustomOver(innerPanel, i);
            // });
            // innerPanel.SetPanelEvent('onmouseout', function() {
                // TipsOut();
            // });

            panel.style.marginLeft = position[key].x + '%';
            panel.style.marginTop = position[key].y + '%';
        })(i);
    }
}

function init_diff(id){
	var diff = id[1]
	$.Msg(id)
	var hittestBlocker = $.GetContextPanel().GetParent().FindChild("SidebarAndBattleCupLayoutContainer");
	hittestBlocker.visible = false

    var num = 0;

    for (let key in position) {
        if (position.hasOwnProperty(key)) {
            num++;
            ((num) => {

                let innerPanel = $('#Diff_'+num);
				
				$.Msg(num, diff)
				
                if (num <= diff) {
                    innerPanel.SetHasClass("lock", false);
					innerPanel.style.backgroundImage = "url('file://{resources}/images/custom_game/loading_screen/num_unlock.png')";
					
					innerPanel.SetPanelEvent('onmouseactivate', (function(index, id) {
						return function() {
							select_diff(index, id);
						};
					})(num, innerPanel.id));
				
                }

                innerPanel.SetPanelEvent('onmouseover', function() {
                    innerPanel.SetHasClass("hovered", true);
                    TipsCustomOver(innerPanel, num);
                });

                innerPanel.SetPanelEvent('onmouseout', function() {
                    innerPanel.SetHasClass("hovered", false);
                    TipsOut();
                });

               
            })(num);
        }
    }
}

function TipsCustomOver(pos, num)
{
	if (typeof(pos) == 'object'){
		pos = pos.id;
	}
	
	var stats = (50 + 30 * (num - 1)) + '%';
	var armor = (50 + 20 * (num - 1)) + '%';
	var resist = (50 + 10 * (num - 1)) + '%';
	var cd = 100 - ((1.25 - num / 20) * 100)
	var as = (num - 1) * 5
	
	var additional = '';
	if(num >= 16){	
		additional = $.Localize('#diff_add') + '<br>';
	}
	
	$.DispatchEvent( "DOTAShowTextTooltip", $("#" + pos), 
		$.Localize('#diff') + ' ' + num + '<br>' +
		$.Localize('#diff_hp') + ' ' + stats + '<br>' +
		$.Localize('#diff_dmg') + ' ' + stats + '<br>' +
		$.Localize('#diff_armor') + ' ' + armor + '<br>' +
		$.Localize('#diff_resist') + ' ' + resist + '<br>' +
		$.Localize('#diff_cd') + ' ' + -1*cd.toFixed(0) + "%" + '<br>' +
		$.Localize('#diff_as') + ' ' + as + '<br>' + additional + '<br>'+
		$.Localize('#diff_stats'))
}

function TipsOver(pos, message)
{
	if (typeof(pos) == 'object'){
		pos = pos.id
	}
	$.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize('#'+pos));
}

function TipsOut()
{
    $.DispatchEvent( "DOTAHideTitleTextTooltip");
    $.DispatchEvent( "DOTAHideTextTooltip");
}

function select_diff(index, id){
	if ( Players.GetLocalPlayer() == 0) {
		var parentPanel = $.GetContextPanel().FindChildTraverse("Diff_container");
		var difIcons = parentPanel.FindChildrenWithClassTraverse("dif_icon");
		for (var i = 0; i < difIcons.length; i++) {
			var difIcon = difIcons[i];
			// difIcon.ClearPanelEvent("onmouseactivate")
		}
		GameEvents.SendCustomGameEventToServer("choise_diff", {index, id})	
	}
}

function update_diff(t){
	panel = $("#"+t.id)

    var parentPanel = $.GetContextPanel().FindChildTraverse("Diff_container");
    var difIcons = parentPanel.FindChildrenWithClassTraverse("dif_icon");
    for (var i = 0; i < difIcons.length; i++) {
        difIcons[i].style.boxShadow = '0px 0px 0px transparent';
        const Target = difIcons[i].GetParent().FindChildTraverse("Target");
        if(Target){
            Target.DeleteAsync(0)
        }
    }
	panel.style.boxShadow = '0px 0px 20px green';
	var TabPanel = $.CreatePanel("Panel", panel.GetParent(), "Target");
}	


function back(t){
	c = $("#"+t).Children("images-back")
	c[1].visible = true;
	TipsOver($("#"+t), "sad")
}

function unback(t){
	c = $("#"+t).Children("images-back")
	c[1].visible = false;
	TipsOut()
}


(function(){
	GameEvents.Subscribe( "init_diff", init_diff)
	GameEvents.Subscribe( "update_diff", update_diff)
})();