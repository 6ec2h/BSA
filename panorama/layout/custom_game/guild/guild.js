var show_all = false;
var can_up = true
var need = 0
var next = 0
var create_guild_state = false;
$("#Guild_menu_container").visible = false;
$("#Guild_menu_container_list").visible = false;
$("#Guild_create_panel").visible = false;
$("#guild_rune_button").visible = false;
$("#guild_aegis_button").visible = false;
$("#Guild_menu_member_leave_accept").visible = false;
var invopened = false

const DotaHUD = GameUI.CustomUIConfig().DotaHUD;
DotaHUD.windowControllers["guild"] = {
    is_open: false,
    open: function(){
        GameEvents.SendCustomGameEventToServer("get_game_guilds", {})
    },
    close: function(){
        $("#Guild_menu_container").visible = false;
		$("#Guild_menu_container_list").visible = false;
    }
}
DotaHUD.ListenToMouseEvent(
    DotaHUD.GetCloseWindowOnOutsideClick($("#Guild_menu_content"), "guild")
);

var rew_localization = {
	'reward_1':50,
	'reward_2':0.25,
	'reward_3':0.5,
	'reward_4':1.0,
	'reward_5':0.25,
	'reward_6':0.2,	
	'reward_7':5,	
	'reward_8':1,	
}

function closeButton()
{
	open()
}

function open() {
	if(DotaHUD.IsWindowOpen("guild")){
		DotaHUD.WindowClose("guild");
	}else{
		DotaHUD.WindowOpen("guild");
	}
}



function ShowAll() {
	show_all = !show_all
	$("#Guild_panel_all").SetHasClass("show_all_set",show_all)
	if (!show_all) {
		$("#Guild_panel_all_button").style.animationName = 'rotate2'
	}else{
		$("#Guild_panel_all_button").style.animationName = 'rotate'
	}
}


function hard_close() {
	$("#Guild_menu_container").visible = false;
	$("#Guild_menu_container_list").visible = false;
	invopened = !invopened
}

function update() {
	GameEvents.SendCustomGameEventToServer("get_game_guilds", {})
	if(invopened){
		if ($("#Guild_menu_container").visible == true){
			$("#Guild_menu_container").visible = false
			$("#Guild_menu_container_list").visible = true;
		}else if($("#Guild_menu_container_list").visible == true){
			$("#Guild_menu_container_list").visible = false
			$("#Guild_menu_container").visible = true;
		}
		invopened = !invopened
		return
	}	
}

function point_feedback(){
	can_up = true
	$("#Guild_menu_container").visible = false
	GameEvents.SendCustomGameEventToServer("get_game_guilds", {})
}

///////////////////////////////////////////////////////////////////////////////////

function create_guild(){
	create_guild_state = !create_guild_state
	$("#Guild_create_panel").visible = create_guild_state;
}

function create_guild_request(){
	guild_name = $("#guild_name_input").text
	if (guild_name.length < 1 || guild_name == $.Localize("#input_guild_name") || guild_name == ''){
		$("#guild_name_input").text = $.Localize("#input_guild_name")
	}else{	
		GameEvents.SendCustomGameEventToServer("create_game_guilds", {name:guild_name, image:guild_image})
		create_guild()
	}
	$("#guild_name_input").text = ''
}

////////////////////////////////////////TIPS//////////////////////////////////////////


function TipsOver(message, pos)
{
    if ($("#"+pos) != undefined){
		if (pos == "Guild_menu_exp_icon"){
			$.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize(next +" из "+need));
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

//////////////////////////////////////////////////////////////////////////////////
		
function guild_list(t){
	tab = t.all_guilds
    invopened = !invopened
    $("#Guild_menu_container_list").visible = invopened;
    panel = $("#Guild_menu_container_list_content");
    panel.RemoveAndDeleteChildren();
	const keys = Object.values(tab).sort((a, b) => b.experience - a.experience);

	
	for (let i = 0; i < keys.length; i++) {
		const guild = keys[i];
        var tabs = GetGuildLevel(guild.experience);
        var GuildList = $.CreatePanel("Panel", panel, "Guild_list_card_" + i);
        GuildList.BLoadLayoutSnippet("guild_list");		
        GuildList.FindChildInLayoutFile("Guild_menu_container_list_icon").style.backgroundImage = "url('file://{resources}/images/guild/guild_icons/" + guild.guild_image + ".png')";
        GuildList.FindChildInLayoutFile("Guild_menu_container_list_name").text = guild.name;
        GuildList.FindChildInLayoutFile("Guild_menu_container_list_level").text = $.Localize("#level") + " " + tabs.level;
        GuildList.FindChildInLayoutFile("Guild_menu_container_list_count").text = $.Localize("#members") + " " + guild.members_count + "/" + guild.max_members;
        GuildList.FindChildInLayoutFile("Guild_menu_container_list_card_button").SetPanelEvent('onmouseactivate', (function (Guild) {
            return function () {add_member(guild)};
        })(GuildList));
        if (guild.members_count == guild.max_members) {
            GuildList.FindChildInLayoutFile("Guild_menu_container_list_card_button").visible = false;
        }
    }
}

function date_conv(dateString){
	let date = new Date(dateString);
	let year = date.getFullYear();
	let month = String(date.getMonth() + 1).padStart(2, '0');
	let day = String(date.getDate()).padStart(2, '0');

	let formattedDate = `${year}-${month}-${day}`;
	return formattedDate	
}

function all_in_guild_list(tab){
    panel = $("#Guild_panel_all");
	const keys = Object.values(tab).sort((a, b) => b.experience - a.experience);
    panel.RemoveAndDeleteChildren();
    for (let key in keys) {
        const guild = keys[key];
        var tabs = GetGuildLevel(guild.experience);
        var GuildList = $.CreatePanel("Panel", panel, "Guild_list_card_" + key);
        GuildList.BLoadLayoutSnippet("guild_list_in_guild");      
        GuildList.FindChildInLayoutFile("Guild_all_icon").style.backgroundImage = "url('file://{resources}/images/guild/guild_icons/" + guild.guild_image + ".png')";
        GuildList.FindChildInLayoutFile("Guild_all_name").text = guild.name;
        GuildList.FindChildInLayoutFile("Guild_all_level").text = $.Localize("#level") + " " + tabs.level;
        GuildList.FindChildInLayoutFile("Guild_all_count").text = guild.members_count + "/" + guild.max_members;
    }
}


function guild_window(t) {
	all_in_guild_list(t.all_guilds)
	
	invopened = !invopened
	$("#guild_rune_button").visible = false;
	$("#guild_aegis_button").visible = false;
	$("#Guild_menu_member_buy_slots").visible = false;
	$("#Guild_menu_reset").visible = false;

	$("#Guild_menu_container").visible = true;
	$("#Guild_menu_icon").style.backgroundImage = "url('file://{resources}/images/guild/guild_icons/" + t.guild_image + ".png')";
	$("#Guild_menu_name").text = t.guild_name
	
	if (t.perm_reward_2 == 1){
		$("#guild_rune_icon").style.brightness = "1"
	}
	if (t.perm_reward_1 == 1){
		$("#guild_aegis_icon").style.brightness = '1'
	}
	
	var tabs = GetGuildLevel(t.guild_exp)
	$('#Guild_menu_icon_pr_bar').style.width = (260/100 * tabs.percent) + "px";	
	$("#Guild_menu_icon_lvl_text").text = tabs.level

	var guild_master_permission = false;
	var steamID = Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_steamid;
	if (steamID == t.guild_master) {
		guild_master_permission = true;
	}
	var panel = $("#Guild_menu_member_list")
	panel.RemoveAndDeleteChildren();
	const mem = Object.keys(t.members);
	
	for (let i = 0; i < mem.length; i++) {
		const key = mem[i];
		const member = t.members[key];
		var MemberList = $.CreatePanel("Panel", panel, "Member_" + i);
		MemberList.BLoadLayoutSnippet("member_list");
		MemberList.FindChildInLayoutFile("member_card_icon").steamid = member.member_id;
		MemberList.FindChildInLayoutFile("member_card_name").steamid = member.member_id;
		MemberList.FindChildInLayoutFile("member_card_remove").visible = guild_master_permission;
		MemberList.FindChildInLayoutFile("member_card_date").text = date_conv(member.last_game)
		MemberList.FindChildInLayoutFile("member_card_remove").SetPanelEvent('onmouseactivate', (function (Member) {
		return function () {remove_member(Member.FindChildInLayoutFile("member_card_remove"))};
		})(MemberList));
	}
	
	$("#members_count").text = t.members_count+"/"+t.guild_max_members
	
	if (guild_master_permission) {	
		$("#Guild_menu_reset").visible = true;
		if(t.guild_max_members < 40){
			$("#Guild_menu_member_buy_slots").visible = true;
		}
		$("#Member_0").FindChildInLayoutFile("member_card_remove").visible = false;
		$("#Guild_menu_member_leave_text").text = $.Localize("#leave_gm")
		if (t.perm_reward_2 == 0){
			$("#guild_rune_button").visible = true;
		}
		if (t.perm_reward_1 == 0){
			$("#guild_aegis_button").visible = true;
		}
	}else{	
		$("#Guild_menu_member_leave_text").text = $.Localize("#leave")
	}
	
	var panel2 = $("#Guild_menu_content_top_right");
	panel2.RemoveAndDeleteChildren();
	const rewKeys = Object.keys(t.rewards);


	for (let i = 1; i < rewKeys.length + 1; i++) {
		const reward = t.rewards['reward_'+i];

		var RewardList = $.CreatePanel("Panel", panel2, "reward_" + i);
		RewardList.BLoadLayoutSnippet("reward_list");
		RewardList.FindChildInLayoutFile("pass_cart_label").text = "+" + ((rew_localization["reward_"+ i]*(reward))).toFixed(1) + $.Localize("#reward_"+ i);
		RewardList.FindChildInLayoutFile("pass_cart_image_quest").style.backgroundImage = "url('file://{resources}/images/guild/rewards/reward_"+ i + ".png')";
		RewardList.FindChildInLayoutFile("pass_cart_image_quest").style.backgroundSize = "100%";
		
		(function(RewardList, i) {
            RewardList.SetPanelEvent("onmouseover", function() {
                $.DispatchEvent("DOTAShowTextTooltip", RewardList, $.Localize('#next_'+i));
            });
            RewardList.SetPanelEvent("onmouseout", TipsOut);
        })(RewardList, i);
		
		if (t.guild_points > 0 && guild_master_permission == true){
			RewardList.style.boxShadow = "#e29737 0px 0px 2px 2px";
			RewardList.SetPanelEvent('onmouseactivate', (function (Reward) {
			return function () {add_guild_skill_point(Reward)};
			})(RewardList));
		}
	}
	update_chat_loop()
}

function update_chat_loop(){
	GameEvents.SendCustomGameEventToServer("update_chat_message", {})
	$.Schedule(5, () => {
		if (invopened){
			update_chat_loop()
		}
	});
}

function add_guild_skill_point(pan){
	if(can_up == true){
		can_up = false
		GameEvents.SendCustomGameEventToServer("add_reward_point", {reward_id : pan.id})
	}
}	

function add_member(t){
	$.Msg(t)
	GameEvents.SendCustomGameEventToServer("add_member", t)
}

function remove_member(t){
	var parent = t.GetParent()
	parent.visible = false;
	var player_id = parent.FindChildInLayoutFile("member_card_name").steamid
	GameEvents.SendCustomGameEventToServer("remove_member", {sid:player_id})
}

function leave_guild(){
	$("#Guild_menu_member_leave_accept").visible = true;
}

function leave_guild_yes(){	
	var steamID = Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_steamid;
	GameEvents.SendCustomGameEventToServer("remove_member", {sid:steamID})
	$("#Guild_menu_member_leave_accept").visible = false;
}

function leave_guild_no(){
	$("#Guild_menu_member_leave_accept").visible = false;
}

////////////////////////////////////////////////////////

var guild_image = 1;
var availableIndexTable = [1, 2, 3, 4, 5, 6, 7, 8];

function NextImage() {
	guild_image++;
	if (guild_image > availableIndexTable.length) {
		guild_image = 1;
	}
	$("#Guild_image_contant").style.backgroundImage = "url('file://{resources}/images/guild/guild_icons/" + guild_image + ".png')";
}

function PrevImage() {
	guild_image--;
	if (guild_image < 1) {
		guild_image = availableIndexTable.length;
	}
	$("#Guild_image_contant").style.backgroundImage = "url('file://{resources}/images/guild/guild_icons/" + guild_image + ".png')";
}

function GetGuildLevel(experience){
	var experienceNeeded = 1000
	var pervLevel = 0
	var nextLevel = 1000
	var now_exp = experience
	var level = 1
	while (experience >= experienceNeeded){
		experience = experience - experienceNeeded
		level = level + 1
		pervLevel = pervLevel + experienceNeeded
		experienceNeeded = experienceNeeded + 500
		nextLevel = nextLevel + experienceNeeded
	}	
	need = nextLevel-pervLevel
	next = now_exp-pervLevel
	var percent = Math.floor(now_exp-pervLevel)/(nextLevel-pervLevel) * 100
	return {level:level, percent:percent, need:need, next:next}
}

var can_send_message = true

function SendChatMessage(){
	var chat_input = $("#guild_chat_input")
	if (chat_input.text == "" || can_send_message == false) return;
	var chat_text = chat_input.text
	can_send_message = false
	chat_input.style.backgroundColor = 'red'
	GameEvents.SendCustomGameEventToServer("send_message", {text:chat_text})
	chat_input.text = "";
	$.Schedule(5, () => {
		can_send_message = true
		chat_input.style.backgroundColor = 'gray'
	});
}

function update_chat(t) {
	var steamID = Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_steamid;
    var chat_panel = $("#guild_chat_text");
    chat_panel.RemoveAndDeleteChildren();
    const rewKeys = Object.keys(t.messages);
    for (let i = 1; i <= rewKeys.length; i++) {
        var MessageList = $.CreatePanel("Panel", chat_panel, "message_" + i);
        MessageList.BLoadLayoutSnippet("chat_list");
		MessageList.AddClass("guild_chat_message")
        MessageList.FindChildInLayoutFile("guild_chat_message_icon").steamid =  t.messages[i].user
        MessageList.FindChildInLayoutFile("guild_chat_message_text").text = t.messages[i].text
		if (steamID == t.messages[i].user) {
			MessageList.MoveChildBefore(MessageList.GetChild(1), MessageList.GetChild(0));
			MessageList.FindChildInLayoutFile("guild_chat_message_icon").style.horizontalAlign = "right";
			MessageList.style.horizontalAlign = "right";
		}
    }
	chat_panel.ScrollToTop();
	chat_panel.ScrollToBottom();
}

function buy_guild_permanent_buff(t){
	GameEvents.SendCustomGameEventToServer("buy_permanent_reward", {reward_name:t})
}

function buy_slot(){
	GameEvents.SendCustomGameEventToServer("buy_slot", {})
}

function reset(){
	GameEvents.SendCustomGameEventToServer("reset_guild", {})
}

////////////////////////////////////////////////////////


(function(){
	GameEvents.Subscribe( "guild_list", guild_list)
	GameEvents.Subscribe( "guild_window", guild_window)
	GameEvents.Subscribe( "update", update)
	GameEvents.Subscribe( "update_chat", update_chat)
	GameEvents.Subscribe( "point_feedback", point_feedback)
	// GameUI.CustomUIConfig.GuildHardClose = hard_close;
})();