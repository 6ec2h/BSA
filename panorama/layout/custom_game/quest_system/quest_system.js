var quest_system = $("#quest_system")
var quest_system_main = $("#quest_system_main")
var quest_system_additional = $("#quest_system_additional")
var QuestMsgPanel = $("#QuestMsgPanel")

show = false

var quests_system = {};

function CreateNewQuest(data)
{
	var quest = InitNewQuest(data.name, data.description, data.target, data.goal, data.type, data.priority, data.rewards)
	quest.tag = data.id;
	quests_system[data.id] = quest
	
	show_text({description : data.description})
}

function debug(){
	show_text('fail')
}


function InitNewQuest(name, description, target, goal, type, priority, rewards)
{
	if (priority == 'main'){
		quest_panel = quest_system_main
	}else{
		quest_panel = quest_system_additional
	}
	
	var panel = $.CreatePanel('Panel', quest_panel,'');
	panel.BLoadLayoutSnippet("Quest");
	
	panel.FindChildTraverse('QuestTitle').text = $.Localize("#"+name);
	
	$.Msg(target)
	
	if (type == 'bring'){
		panel.FindChildTraverse('QuestDiscription').text = $.Localize("#"+description) + " " + $.Localize("#DOTA_Tooltip_ability_"+target)
	}else{
		panel.FindChildTraverse('QuestDiscription').text = $.Localize("#"+description);
	}
	panel.FindChildTraverse('GoldRewardTitle').text = rewards.gold
	panel.FindChildTraverse('ExpRewardTitle').text = rewards.exp
	
	panel.name = name;
	panel.desc = description;
	panel.goal = goal;
	panel.current = 0;
	
	SetQuestProgress(panel, 0, goal, type)
	return panel;
}

function SetQuestProgress(quest, current, goal, type)
{
	if (type == 'kill' || type == 'clear' || type == 'collect'){
		quest.FindChildTraverse('QuestProgress').text = current + "/" + goal;
	}else{
		quest.FindChildTraverse('QuestProgress').text = "";
	}
	var percent = (current / goal);
	var background = quest.FindChildTraverse("Background");
	background.style.width = (percent * 100) + "%";
	quest.goal = goal;
	quest.current = current;
}
		
function OnQuestUpdateProgress(data)
{
	for (var x in quests_system)
	{
		quest = quests_system[x];
		if (quest.tag == data.id)
		{
			SetQuestProgress(quest, data.current, data.goal, data.type);
			break;
		}
	}
}

function OnQuestRemove(data)
{
	
	for (var x in quests_system)
	{
		quest = quests_system[x];
		if (quest.tag == data.num)
		{
			quest.DeleteAsync(0);
			delete quests_system[data.num]
			
			show_text(data)
			
			break;
		}
	}
}

function show_text(data) {
    var color = '#FF8000';
	var quest_status = 'new_quest'
    if (data.status === 'success') {
        color = '#14b814';
		quest_status = 'success_quest'
    }
    if (data.status === 'fail') {
        color = '#FF0000';
		quest_status = 'fail_quest'
    }

    var questMsg = $.CreatePanel("Label", QuestMsgPanel, "");
    questMsg.AddClass("quest_message");
    questMsg.html = true;
    questMsg.text = "<font color='" + color + "'>" + $.Localize("#"+quest_status) + " " + $.Localize("#" + data.description) + "</font>";

    $.Schedule(3, function() {
        questMsg.DeleteAsync(0);
    });
}




(function(){
	GameEvents.Subscribe( "quest_system_init", CreateNewQuest)
	GameEvents.Subscribe( "quest_system_update", OnQuestUpdateProgress)
	GameEvents.Subscribe( "quest_system_remove", OnQuestRemove)
	GameEvents.Subscribe( "debug", debug)
})();


