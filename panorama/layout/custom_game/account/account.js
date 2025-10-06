$("#ban").visible = false
$("#AccountPanel").visible = false;
$("#AcceptReset").visible = false
var parentPanel = $("#main_content");
// $("#AcceptReset").visible = false


var open = false;
var plysteamid = Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_steamid;

const DotaHUD = GameUI.CustomUIConfig().DotaHUD;
DotaHUD.windowControllers["account"] = {
    is_open: false,
    open: function(){
        current_offset_x = 0;
		current_offset_y = 0;
		parentPanel.SetPositionInPixels(current_offset_x, current_offset_y, 20);
		parentPanel.RemoveAndDeleteChildren()
		
		let loading = $.CreatePanel("Panel", parentPanel, 'loading', {class:'loading'})
		
		GameEvents.SendCustomGameEventToServer("get_account_progress", {})
		$("#AccountPanel").visible = true;
    },
    close: function(){
        $("#AccountPanel").visible = false;
    }
}
DotaHUD.ListenToMouseEvent(
    DotaHUD.GetCloseWindowOnOutsideClick($("#main"), "account")
);

function openaccountButton(){
	if(DotaHUD.IsWindowOpen("account")){
		DotaHUD.WindowClose("account");
	}else{
		DotaHUD.WindowOpen("account");
	}
}

var min = 0.2;
var max = 1;
var offset = 0;
var STEP = 0.05;

var start_pos;
var current_offset_x = 0;
var current_offset_y = 0;

var max_offset_x = 2000;
var min_offset_x = -2000;
var max_offset_y = 2000;
var min_offset_y = -2000;

let isDragging = false;

function fun(eventType, clickBehavior) {	
    if (eventType === "pressed") {
        start_pos = GameUI.GetCursorPosition();
        isDragging = true;
        $.Schedule(0.01, UpdatePosition);
    }

    if (eventType === "released") {
        isDragging = false;
    }

    if (eventType === "wheeled") {
        if (clickBehavior > 0) {
            if ((1 + offset + STEP) <= max) {
                offset += STEP;
            }
        } else {
            if ((1 + offset - STEP) >= min) {
                offset -= STEP;
            }
        }

        parentPanel.style.transform = "scale3D(" + (1 + offset) + ", " + (1 + offset) + ", " + (1 + offset) + ")";

        if (offset < -0.75) {
            parentPanel.SetPositionInPixels(0, 0, 20);
        }
    }
}

DotaHUD.ListenToMouseEvent(fun);

function UpdatePosition() {
    if (!isDragging || !GameUI.IsMouseDown(0)) return;

    const t = GameUI.GetCursorPosition();

    if (start_pos && Array.isArray(start_pos) && start_pos.length >= 2) {
        var ofx = start_pos[0] - t[0];
        var ofy = start_pos[1] - t[1];
    } else {
        var ofx = 0;
        var ofy = 0;
    }

    var new_offset_x = current_offset_x - ofx;
    var new_offset_y = current_offset_y - ofy;

    new_offset_x = Math.max(min_offset_x * (0.8 + offset), Math.min(max_offset_x * (0.8 + offset), new_offset_x));
    new_offset_y = Math.max(min_offset_y * (0.8 + offset), Math.min(max_offset_y * (0.8 + offset), new_offset_y));

    parentPanel.SetPositionInPixels(new_offset_x, new_offset_y, 20);

    current_offset_x = new_offset_x;
    current_offset_y = new_offset_y;

    start_pos = t;

    $.Schedule(0.01, UpdatePosition);
}

function createPanel(talent) {
	var x = talent.x
	var y = talent.y
	var size = talent.size
	var color = talent.color
	var id = talent.id
	var requires = talent.requires
	var bonus = talent.bonus
	
    var panel = $.CreatePanel("Panel", parentPanel, id, {class: 'mainpanel'});
    panel.style.marginTop = x-size/2 + "px";
    panel.style.marginLeft = y-size/2 + "px";
    panel.style.width = size+"px"; // Размер точки
    panel.style.height = size+"px"; // Размер точки
    panel.style.backgroundColor = 'black'; // Цвет точки
    panel.style.borderRadius = "50%"; // Круглая форма
	
	var image_name = getTalentName(bonus)
	
	if (image_name == 'bonus_str' || image_name == 'bonus_agi' || image_name == 'bonus_int'){
		panel.style.backgroundImage = "url('file://{resources}/images/account/"+bonus+".png')";
	}else{
		 panel.style.backgroundImage = "url('file://{resources}/images/account/"+image_name+".png')";
	}
   
    panel.style.backgroundSize = "100%";
	
    panel.SetPanelEvent("onmouseover", function() { $.DispatchEvent("DOTAShowTextTooltip", panel, $.Localize('#')+bonus)});
	panel.SetPanelEvent("onmouseout", TipsOut)
		

	
	if (learnedTalents.includes(id)){
		panel.AddClass('learn')
	}else{
		panel.AddClass('not_learn')
		
	}
	
	// var panel = $.CreatePanel("Label", panel, '', {class:'centerlabel'});
	// panel.text = id
}

function getTalentName(str) {
	if(str){
		return str.replace(/_\d+$/, '')
	}
}


function createPattern(talents) {
	Object.entries(talents).forEach(([key, talent]) => {
        createPanel(talent);
    });
	
	Object.entries(talents).forEach(([key, talent]) => {
	   if (canLearnTalent(talent.id, learnedTalents, talents) && !learnedTalents.includes(talent.id)){
		   
			parentPanel.FindChildInLayoutFile(talent.id).SetPanelEvent("onmouseactivate", () => acceptBuy(talent.id));
			
			let panel = $.CreatePanel("DOTAParticleScenePanel", parentPanel.FindChildInLayoutFile(talent.id), "", {
				particleName: "particles/ui/battle_pass/device_spin_ring.vpcf",
				renderdeferred: "true",
				particleonly: "false",
				startActive: "true",
				cameraOrigin: "0 0 90",
				lookAt: "0 0 0",
				fov: "10"
			});
			
			if (skill_points > 0){
				$.Msg("can upgrade")
			}else{
				$.Msg("can't upgrade")
			}
			
			panel.AddClass("very_rare_item_effect");
	   }
	})
}


function canLearnTalent(talentId, learnedTalents, talents) {
  const talent = Object.values(talents).find(t => t.id == talentId);
  if (!talent) return false;
  const hasRequiredTalents = Object.values(talent.requires).every(req => learnedTalents.includes(req));
  const hasAlternativeTalents = Object.values(talent.alternative).some(alt => learnedTalents.includes(alt));
  return hasRequiredTalents || hasAlternativeTalents;
}

function createParentInfo(data){
	var {level, percent, need, nexp} = GetHeroLevel(data.player_exp);
	
	var panel = $.CreatePanel("Panel", parentPanel, 'player_data', {});
	panel.BLoadLayoutSnippet("player_data");
	panel.FindChildTraverse('profname').steamid = plysteamid
	panel.FindChildTraverse('profavatar').steamid = plysteamid
	panel.FindChildTraverse('proflevel').text = $.Localize('#level') + ': ' + level
	panel.FindChildTraverse('profbar').style.width = percent + '%'
	panel.FindChildTraverse('skill_points').text = skill_points
	if (data.free_reset == 0) {
		panel.FindChildTraverse('reset_text').text = "50 RESET"
	}else{
		panel.FindChildTraverse('reset_text').text = "FREE"
	}
}

	
function init_account(data){
	parentPanel.RemoveAndDeleteChildren()
	var talents = data.talents_data
	var player_data = data.player_talents
	
	skill_points = player_data.skill_points
	learnedTalents = Object.values(player_data.talents)
	
	createParentInfo(player_data)
	createPattern(talents);
}

function GetHeroLevel(experience){
	var experienceNeeded = 150
	var pervLevel = 0
	var nextLevel = 150
	var now_exp = experience
	var level = 1
	while (experience >= experienceNeeded){
		experience = experience - experienceNeeded
		level = level + 1
		pervLevel = pervLevel + experienceNeeded
		experienceNeeded = experienceNeeded + 15
		nextLevel = nextLevel + experienceNeeded
	}	
	var need = nextLevel-pervLevel
	var nexp = now_exp-pervLevel
	var percent = Math.floor(now_exp-pervLevel)/(nextLevel-pervLevel)*100
	return {level:level, percent:percent, need:need, nexp:nexp}
}

function reset_acc(){
	$.Msg("reset")
	$("#AcceptReset").visible = true
	$('#AcceptResetYes').SetPanelEvent("onmouseactivate", yes_reset)
	$('#AcceptResetNo').SetPanelEvent("onmouseactivate",no_reset)
}

function yes_reset()
{
	$("#AcceptReset").visible = false
	GameEvents.SendCustomGameEventToServer( "reset_account_progress", {})
}

function no_reset()
{
	$("#AcceptReset").visible = false
}

function acceptBuy(id) {
	GameEvents.SendCustomGameEventToServer( "buy_account_progress", {id:id});
}

function TipsOver(message, pos)
{
     if ($("#"+pos) != undefined)
    {
		if (pos == "Exp_line"){
			$.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize(nexp_exp +" / "+need_exp));
		}else{
			$.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize('#'+message));
		}
    }
}

function TipsOut()
{
    $.DispatchEvent( "DOTAHideTitleTextTooltip");
    $.DispatchEvent( "DOTAHideTextTooltip");
}


function ban(){
	$("#ban").visible = true
}

(function(){
	GameEvents.Subscribe( "ban", ban);
	GameEvents.Subscribe( "init_account", init_account)
})();