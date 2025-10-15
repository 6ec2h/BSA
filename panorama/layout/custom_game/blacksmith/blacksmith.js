var blacksmith_panel_main = $("#blacksmith_panel_main");
var blacksmith_target = $("#blacksmith_target");
var blacksmith_result = $("#blacksmith_result");
var blacksmith_description = $("#blacksmith_description");
var blacksmith_errors_label = $("#blacksmith_errors_label");
var loading;
var button;
var t;
var boost = 0;
blacksmith_panel_main.visible = false

var decription_attributes = CustomNetTables.GetTableValue( "set_attributes", 'set_attributes')
var boost_attributes = CustomNetTables.GetTableValue( "boost_attributes", 'boost_attributes')

const DotaHUD = GameUI.CustomUIConfig().DotaHUD;
DotaHUD.windowControllers["blacksmith"] = {
    is_open: false,
    open: function(){
        GameEvents.SendCustomGameEventToServer("get_items_upgrade", {});
    },
    close: function(){
        close()
    }
}
DotaHUD.ListenToMouseEvent(
    DotaHUD.GetCloseWindowOnOutsideClick(blacksmith_panel_main, "blacksmith")
);

function ActivateBlacksmith() {
	
	DotaHUD.WindowOpen("blacksmith");
}

function DeactivateBlacksmith(){
	DotaHUD.WindowClose("blacksmith");
}

function close(){
	blacksmith_panel_main.visible = false
}

function blacksmith_init(tab){
    DotaHUD.WindowCloseAnyway("inventory_hud")
	t = tab.hero_inventory
	
	boost = tab.upgrade_boost
	
	// GameUI.CustomUIConfig.CloseInventory();
	
	$("#DustPaneLabel").text = tab.dust
	
	$("#BlacksmithInventorySlots").RemoveAndDeleteChildren()
	blacksmith_panel_main.visible = true
	UpdateInventorySlots()
	UpdateInventoryItems(t)
}

function UpdateInventorySlots() // Создание слота для инвентаря
{
    for (let i = 1; i <= 30; i++)
    {
        let inventory_slot = $.CreatePanel("Panel", $("#BlacksmithInventorySlots"), "inventory_slot_"+i)
		inventory_slot.AddClass("inventory_slot")
		inventory_slot.slot_count = i
		inventory_slot.SetPanelEvent("onmouseover", onAbilityMouseOver.bind(this, inventory_slot));
		inventory_slot.SetPanelEvent("onmouseout", onAbilityMouseOut.bind(this, inventory_slot));
    }
}

function UpdateInventoryItems(inventory_list) // Апдейт всех предметов инвентаря
{
	blacksmith_errors_label.visible = false
	
    for (let i = 0; i <= Object.keys(inventory_list).length; i++)
    {
        if (Object.keys(inventory_list)[i] != null)
        {
            let inventory_key_slot = Object.keys(inventory_list)[i]
            let item_info = inventory_list[inventory_key_slot]
            if (item_info != null)
            {
                let item_name = item_info.name
                let item_type = item_info.type
                let item_attributes = item_info.attributes
                let item_icon = item_info.set_type + "/" + item_info.item_type
                
                let find_slot = $("#BlacksmithInventorySlots").FindChildTraverse("inventory_slot_"+inventory_key_slot)
    
                let item_panel = $.CreatePanel("Panel", find_slot, "")
                item_panel.AddClass("item_panel")
                item_panel.style.backgroundSize = "100%"
                if (item_info.set_type == 'jewell'){
					item_panel.style.backgroundImage = "url('file://{resources}/images/sets/"+item_info.item_type+".png')";
				}else{
					item_panel.style.backgroundImage = "url('file://{resources}/images/sets/" + item_info.set_type + "/" + item_info.item_type +".png')";
                    item_panel.AddClass("equipped_item_shadow_level_" + item_info.level)
                    item_panel.style.backgroundSize = "95%"
                    item_panel.style.backgroundPosition = "center center"
				}
                item_panel.item_icon = item_icon
                item_panel.hittest = false
				
				if (item_info.set_type != 'jewell'){
				
					find_slot.SetPanelEvent("onmouseactivate", function() {
						show_up(inventory_key_slot);
					});
				}		
            }
        }
    }
}

function blacksmith_update(tab) {
	blacksmith_init(tab)
	
	$("#DustPaneLabel").text = tab.dust
	
	if (loading){
		loading.visible = false
		button.visible = true
	}
	blacksmith_errors_label.text = $.Localize("#" + tab.status)
	blacksmith_errors_label.visible = true
	
	show_up(tab.item_number);
	
	if (tab.status == 'success'){
		let item_drop_effect = $.CreatePanel("DOTAParticleScenePanel", $("#blacksmith_select_panel"), "", {particleName:"particles/ui/ui_generic_treasure_impact.vpcf", renderdeferred:"true", particleonly:"false", startActive:"true", cameraOrigin:"0 0 300", lookAt:"0 0 0", fov:"60"})
		item_drop_effect.AddClass("item_drop_effect")
		item_drop_effect.hittest = false
		item_drop_effect.DeleteAsync(3)
		Game.EmitSound("ui.treasure_01")
	}
	if (tab.status == 'fail'){
		Game.EmitSound("high_five.fail")
	}
}

function clear_panel() {
    blacksmith_target.RemoveAndDeleteChildren();
    blacksmith_result.RemoveAndDeleteChildren();
    blacksmith_description.RemoveAndDeleteChildren();
}

function show_up(inventory_key_slot) {
    clear_panel()
    draw(inventory_key_slot);
}

var percentAttributes = ['lifesteal', 'magic_lifesteal', 'reflect', 'spell_amplify', 'magic_desolator', 'hp_regen', 'legs', 'shield', 'manacost', 'hp_regen_amp', 'crit', 'multicast'];
var intNumAttributes = ['head', 'legs', 'weapon'];
	
function draw(inventory_key_slot) {
    var data = t[inventory_key_slot];
    $.Msg("-------------------")
	$.Msg("data:", data)
    $.Msg("inventory_key_slot:", inventory_key_slot)
    $.Msg("data.item_type:", data.item_type)
    $.Msg("-------------------")
    var perc = percentAttributes.includes(data.item_type) ? '%' : '';
    var num = intNumAttributes.includes(data.item_type) ? 0 : 1;

    // Create description panel
    var pan_desc = createDescriptionPanel(data, perc, inventory_key_slot);

    // Create target panel
    createTargetPanel(data, perc, num);

    // Create result panel
    createResultPanel(data, perc, num);

    pan_desc.visible = shouldShowDescription(data.level);
}

function createDescriptionPanel(data, perc, inventory_key_slot) {
    var pan_desc = $.CreatePanel("Panel", blacksmith_description, 'up');
    pan_desc.BLoadLayoutSnippet("blacksmith_up_desc");

    var chanceText = $.Localize("#up_chance") + " " + (100 - (data.level - 1) * 10) + "%";
    if (boost > 0) {
        chanceText += "<font color='#14b814'>" + " + " + boost + "%" + "</font>";
    }
    pan_desc.FindChildTraverse('blacksmith_up_panel_desc_label_chance').text = chanceText;

    var gem_count = data.level //>= 9 ? 1 : data.level;
	var gem_type = data.level >= 9 ? 'soul' : 'bless'
	var visible = data.level >= 11 ? false : true
 
    pan_desc.FindChildTraverse('blacksmith_up_panel_price_label').text = " = " + gem_count;
    pan_desc.FindChildTraverse('blacksmith_up_panel_price_dust_label').text = " = " + data.set_number * 10;
    pan_desc.FindChildTraverse('blacksmith_up_panel_price_image').SetImage('file://{resources}/images/sets/'+gem_type+'.png');
    loading = pan_desc.FindChildTraverse('blacksmith_up_panel_desc_loading')
	loading.visible = false
	pan_desc.visible = visible
	
	setUpgradeButton(pan_desc, data, inventory_key_slot);
	 
    return pan_desc;
}

function createTargetPanel(data, perc, num) {
    var pan = $.CreatePanel("Panel", blacksmith_target, '');
    pan.BLoadLayoutSnippet("blacksmith_up_snippet");
    pan.FindChildTraverse('blacksmith_up_panel_name').text = $.Localize("#" + data.set_type + "_" + data.item_type) + " " + data.level;
    pan.FindChildTraverse('blacksmith_up_panel_image').SetImage('file://{resources}/images/sets/' + data.set_type + '/' + data.item_type + '.png');
    pan.FindChildTraverse('blacksmith_up_panel_base').text = $.Localize("#" + data.item_type + "_description") + (decription_attributes[data.item_type] * data.level * data.set_number) + perc;

    createBonusPanel(pan.FindChildTraverse('blacksmith_up_panel_bonus'), data.bonus_attribute, data.set_number, data.level, perc, num);
}

function createResultPanel(data, perc, num) {
    var result_panel = $.CreatePanel("Panel", blacksmith_result, '');
    result_panel.BLoadLayoutSnippet("blacksmith_up_snippet");
    
    var level_up = data.level + 1;
    result_panel.FindChildTraverse('blacksmith_up_panel_name').text = $.Localize("#" + data.set_type + "_" + data.item_type) + " " + level_up;
    result_panel.FindChildTraverse('blacksmith_up_panel_image').SetImage('file://{resources}/images/sets/' + data.set_type + '/' + data.item_type + '.png');
    result_panel.FindChildTraverse('blacksmith_up_panel_base').text = $.Localize("#" + data.item_type + "_description") + (decription_attributes[data.item_type] * level_up * data.set_number) + perc;

    createBonusPanel(result_panel.FindChildTraverse('blacksmith_up_panel_bonus'), data.bonus_attribute, data.set_number, level_up, perc, num);

	var visible = data.level >= 11 ? false : true
	result_panel.visible = visible
	
   
}

function createBonusPanel(panel, bonusAttributes, set_number, level, perc, num) {
    for (const attrKey in bonusAttributes) {
        let label = $.CreatePanel("Label", panel, "");
        label.AddClass('bonus_label');
        
        let attrPerc = percentAttributes.includes(attrKey) ? '%' : '';
        let attrNum = intNumAttributes.includes(attrKey) ? 0 : 1;

        // label.text = $.Localize("#" + attrKey + "_description") + " " + (decription_attributes[attrKey] + (set_number * 0.1 * level) - set_number * 0.1).toFixed(attrNum) + attrPerc;
        label.text = $.Localize("#" + attrKey + "_description") + " " + (decription_attributes[attrKey] * set_number +  boost_attributes[attrKey][set_number] * (level - 1)).toFixed(attrNum) + attrPerc;
        $.CreatePanel("Panel", panel, "SourceValueLine");
    }
}

function setUpgradeButton(panel, data, inventory_key_slot) {
    button = panel.FindChildTraverse('blacksmith_up_panel_desc_button');
    button.SetPanelEvent("onmouseactivate", function () {
        try_upgrade(data, inventory_key_slot, button);
    });
}

function shouldShowDescription(level) {
    return level < 11;
}

function try_upgrade(data, number, button){
	loading.visible = true
	button.visible = false
    
	GameEvents.SendCustomGameEventToServer("try_items_upgrade", {
		item_id: data.id || data.item_id || null,
		slot_number: parseInt(number)
	})
}

function showTooltip(panel, data) {
    if (data) {
        let params = `&item_data=` + JSON.stringify(data)
        $.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "SetCreepTooltip", "file://{resources}/layout/custom_game/custom_tooltip/custom_tooltip.xml", params);
    }
}

function onAbilityMouseOver(panel) {
	let data = t[panel.slot_count];
	showTooltip(panel, data);
}

function onAbilityMouseOut(panel) {
	$.DispatchEvent("UIHideCustomLayoutTooltip", panel, "SetCreepTooltip");
}

(function() {
   	GameEvents.Subscribe("blacksmith_update", blacksmith_update)
   	GameEvents.Subscribe("blacksmith_init", blacksmith_init)
   	GameEvents.Subscribe("ActivateBlacksmith", ActivateBlacksmith)
	GameEvents.Subscribe("DeactivateBlacksmith", DeactivateBlacksmith)
	GameUI.CustomUIConfig.CloseOrders = close;
})();