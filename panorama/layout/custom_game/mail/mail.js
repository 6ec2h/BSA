var main = $("#MailPanel")
var LeftSide = $("#LeftSide")
var RightSide = $("#RightSide")
var openmail = $("#openmail")
var first = true

const DotaHUD = GameUI.CustomUIConfig().DotaHUD;
DotaHUD.windowControllers["mail"] = {
    is_open: false,
    open: function(){
        main.ToggleClass("hidden")
		LeftSide.RemoveAndDeleteChildren();
		RightSide.RemoveAndDeleteChildren();
		openmail.style.backgroundImage = "url('s2r://panorama/images/mail/mail.png')"
		GameEvents.SendCustomGameEventToServer("get_mails", {})	
    },
    close: function(){
        main.ToggleClass("hidden")
    }
}
DotaHUD.ListenToMouseEvent(
    DotaHUD.GetCloseWindowOnOutsideClick(main, "mail")
);


function openButton()
{
	DotaHUD.WindowOpen("mail");
}

function closeButton()
{
	DotaHUD.WindowClose("mail");
}


function mail_init(t){
	$.Msg("init")
	LeftSide.RemoveAndDeleteChildren();
	var new_message = false
    for (var key in t) {
        var mail = t[key];
        var Mail_Panel = $.CreatePanel("Panel", LeftSide, "Mail_" + key);
        Mail_Panel.BLoadLayoutSnippet("mail_button");
        Mail_Panel.FindChildTraverse('Mail_Label').text = mail.additional_text;
        Mail_Panel.FindChildTraverse('mailfrom').text = mail.from_user;
        Mail_Panel.FindChildTraverse('maildate').text = date_conv(mail.mail_data);
		if (mail.read_status == 0){
			if (first){
				first = false
				openmail.style.backgroundImage = "url('s2r://panorama/images/mail/mail2.png')";
			}
			Mail_Panel.AddClass("read_status")
		}else{
			Mail_Panel.RemoveClass("read_status")
		}
        (function(mail, pan) {
            Mail_Panel.SetPanelEvent("onmouseactivate", function () {
                opn_mail(mail, pan);
            });
        })(mail, Mail_Panel);
    }
}


function opn_mail(mail, pan){
	RightSide.RemoveAndDeleteChildren();
	if (mail.read_status == 0){
		pan.RemoveClass("read_status")
		mail.read_status = 1
		GameEvents.SendCustomGameEventToServer("send_mail_read", {id : mail.id})	
	}
	var Mail_Desc = $.CreatePanel("Panel", RightSide, "Mail_Desc");
	Mail_Desc.BLoadLayoutSnippet("mail_desc");
	Mail_Desc.FindChildTraverse('MailTitle').text = mail.mail_title;
	Mail_Desc.FindChildTraverse('MailText').text = mail.mail_text;
	
	if (Object.keys(mail.additional_dict).length > 0) {
		for (var key in mail.additional_dict) {
			var name = mail.additional_dict[key]
			if (mail.get_item_status == 1){
				RightSide.FindChildTraverse('RightSideButton').visible = false
			}else{
				RightSide.FindChildTraverse('RightSideButton').visible = true
				RightSide.FindChildTraverse('RightSideButton').SetPanelEvent("onmouseactivate", function () {
					RightSide.FindChildTraverse('RightSideButton').visible = false
					GameEvents.SendCustomGameEventToServer("send_mail_reward", {id : mail.id, reward: mail.additional_dict})
					Game.EmitSound("ui.treasure_01")
				})
			}
			
			if (name.includes('item_')){
				const item = $.CreatePanel("DOTAItemImage", RightSide.FindChildTraverse('RightSideItems'), 'item');
				item.AddClass("dota_item")
				item.itemname = name
				const back = $.CreatePanel("Panel", RightSide.FindChildTraverse('RightSideItems'), 'itemback');
				back.hittest = false
				back.AddClass("dota_item_back")
			}else{
				const other = $.CreatePanel("Image", RightSide.FindChildTraverse('RightSideItems'), "other");
				if(name.includes("highfive")){
					other.AddClass("dota_item")
					other.SetImage('file://{resources}/images/highfive/' + name + '.png');
				}
				if(name.includes("spray")){
					other.AddClass("dota_item")
					other.SetImage('file://{resources}/images/spray/' + name + '.png');
				}
				if(name.includes("effect")){
					other.AddClass("dota_item")
					other.SetImage('file://{resources}/images/effect/' + name + '.png');
				}
				const back = $.CreatePanel("Panel", RightSide.FindChildTraverse('RightSideItems'), 'itemback');
				back.hittest = false
				back.AddClass("dota_item_back")
			}
		}
	}else{
		RightSide.FindChildTraverse('RightSideButton').visible = false
	}
}


function date_conv(dateString) {
    let date = new Date(dateString);
    let year = date.getFullYear();
    let month = String(date.getMonth() + 1).padStart(2, '0');
    let day = String(date.getDate()).padStart(2, '0');
    let hours = String(date.getHours()).padStart(2, '0');
    let minutes = String(date.getMinutes()).padStart(2, '0');
    let formattedDate = `${year}-${month}-${day} ${hours}:${minutes}`;
    return formattedDate;
}


function TipsOver(message, pos)
{
	$.DispatchEvent( "DOTAShowTextTooltip", $("#"+pos), $.Localize('#'+message))
}

function TipsOut()
{
    $.DispatchEvent( "DOTAHideTitleTextTooltip")
    $.DispatchEvent( "DOTAHideTextTooltip")
}

(function(){
	main.ToggleClass("hidden")
	GameEvents.Subscribe( "mail_init", mail_init)
})()

