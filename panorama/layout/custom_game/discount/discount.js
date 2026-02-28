const main = $("#DiscountPanel");
const buyControl = $("#BuyControl");
buyControl.visible = false;
main.visible = false;

let isOpened = false;

const DotaHUD = GameUI.CustomUIConfig().DotaHUD;
DotaHUD.windowControllers["discount"] = {
    is_open: false,
    open: function(){
        isOpened = !isOpened;
        main.visible = isOpened;
        if (isOpened) {
            showContent();
        } else {
            buyControl.visible = false;
        }
    },
    close: function(){
        buyControl.visible = false;
        isOpened = false;
        main.visible = isOpened;
    }
}
DotaHUD.ListenToMouseEvent(
    DotaHUD.GetCloseWindowOnOutsideClick(main, "discount")
);

function openButton() {
    DotaHUD.WindowOpen("discount");
}

function closeButton() {
    DotaHUD.WindowClose("discount");
}

function closebuy() {
    buyControl.visible = false;
}

function showContent() {
    ["#leftImage", "#middleImage", "#rightImage"].forEach(CreateVeryRareItemEffect);
}

function CreateVeryRareItemEffect(targetId) {
    let panel = $.CreatePanel("DOTAParticleScenePanel", $(targetId), "", {
        particleName: "particles/ui/dota_hud_armory_selection_icon.vpcf",
        renderdeferred: "true",
        particleonly: "false",
        startActive: "true",
        cameraOrigin: "160 0 0",
        lookAt: "0 0 0",
        fov: "60"
    });
    panel.AddClass("very_rare_item_effect");
    panel.hittest = false;
    return panel;
}

function buy(data) {
    const itemImage = $("#item_buy_image");
    itemImage.style.backgroundImage = `url('file://{images}/${data}.png')`;

    CreateVeryRareItemEffect("#item_buy_image");

    const prices = {
        set_discount: 50,
        bless: 25,
        dust: 15
    };

    const price = prices[data] || 0;
    buyControl.visible = true;

    const buyLabel = buyControl.FindChildTraverse('buy_label');
    const buyButton = buyControl.FindChildTraverse('buy_button');
    
    buyLabel.text = price;
    buyButton.SetPanelEvent("onmouseactivate", () => acceptBuy(price, data));
}

function acceptBuy(price, data) {
    buyControl.visible = false;
    GameEvents.SendCustomGameEventToServer("buy_discount_item", { price, data });
}

function TipsOver(message, pos) {
    $.DispatchEvent("DOTAShowTextTooltip", $("#" + pos), $.Localize('#' + message));
}

function TipsOut() {
    $.DispatchEvent("DOTAHideTitleTextTooltip");
    $.DispatchEvent("DOTAHideTextTooltip");
}

GameUI.LoopTime.Schedule(0.0, ()=>{
    DotaHUD.CreateTopBarButton("file://{images}/discount.png", "discount", openButton, "open_discount");
});

