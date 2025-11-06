const DOTA_HUD_ROOT = $.GetContextPanel().GetParent().GetParent().GetParent();
const topBarPlayersContainer = DOTA_HUD_ROOT.FindChildTraverse("TopBarRadiantPlayersContainer")
const localPlayerId = Players.GetLocalPlayer()
const localPlayerIdStr = String(localPlayerId)
let activeTip = CustomNetTables.GetTableValue( "active_player_tip", localPlayerIdStr)

function print(...args) {
	$.Msg(...args)
}

function getTopBarPlayerContainers() {
	const topBarPlayerContainers = topBarPlayersContainer.GetChildCount()
	const topBarRealPlayerContainers = []
	
	for (let i = 0; i < topBarPlayerContainers; i++) {
		const playerContainer = topBarPlayersContainer.GetChild(i)

		const playerId = playerContainer?.id?.match(/[^-](\d+)/)?.[1]

		if (!playerId)
			continue

		topBarRealPlayerContainers.push({
			playerId: parseInt(playerId),
			container: playerContainer,
		})
	}

	return topBarRealPlayerContainers
}

function destroyOldTipButtons() {
	for (const playerContainerData of getTopBarPlayerContainers()) {
		const oldTipButton = playerContainerData.container.FindChildTraverse("PlayerTipButton");

		if (!oldTipButton?.IsValid())
			continue
		
		oldTipButton.DeleteAsync(0);
	}
}

const tipButtons = {}
let playersCount = 0

function initTipButtons() {
	const topBarPlayerContainers = getTopBarPlayerContainers()
	
	playersCount = topBarPlayerContainers.length

	for (const playerContainerData of topBarPlayerContainers) {
		const playerContainer = playerContainerData.container

		const tpIndicator = playerContainer.FindChildTraverse("TPIndicator")
		if (tpIndicator)
			tpIndicator.style.marginTop = "90px"

		const oldTipButton = playerContainer.FindChildTraverse("PlayerTipButton");

		if (oldTipButton?.IsValid())
			oldTipButton?.DeleteAsync(0);

		const playerId = playerContainerData.playerId

		if (playerId === localPlayerId)
			continue

		const tipButton = $.CreatePanel("Button", $("#TipsTempRoot"), "PlayerTipButton");
		tipButton.playerId = playerId
		tipButton.BLoadLayoutSnippet("PlayerTipButton");
		tipButton.SetPanelEvent("onmouseactivate", () => {
			if (tipButton.BHasClass("OnCooldown") || tipButton.BHasClass("NoActiveTip"))
				return

			GameEvents.SendCustomGameEventToServer( "do_player_tip", {targetId: playerId});
		})
		tipButton.SetHasClass("NoActiveTip", !activeTip)

		tipButton.SetParent(playerContainer)

		tipButtons[playerId] = tipButton
	}
}

let nextTipTime = 0
let tipTextIsCooldown

const tipToastsContainer = $("#PlayerTipToastsContainer")

function setupToast(toastPanel, playerId, isSource) {
	const info = Game.GetPlayerInfo(playerId);

	const heroContainer = toastPanel.FindChildrenWithClassTraverse(isSource ? "SourceHeroContainer" : "TargetHeroContainer")[0];

	heroContainer.GetChild(0).SetImage(`file://{images}/heroes/${info.player_selected_hero}.png`)
	heroContainer.GetChild(1).text = info.player_name;
}

function successTip(data) {
	if (data.sourcePlayerId === localPlayerId) {
		nextTipTime = Game.GetGameTime() + data.cooldown
		handleTipCooldown()
	}

    Game.EmitSound("General.Coins")

	const tipToast = $.CreatePanel("Panel", tipToastsContainer, "PlayerTipToastContainer");
    tipToast.BLoadLayoutSnippet("PlayerTipToast");

	setupToast(tipToast, data.sourcePlayerId, true);
	setupToast(tipToast, data.targetPlayerId, false);

	const tipImageContainer = tipToast.FindChildrenWithClassTraverse("TipTextContainer")[0];
	tipImageContainer.GetChild(0).SetImage(`file://{images}/custom_game/tips/${data.tip}.png`);

	tipToast.AddClass("IsVisisble");
	$.Schedule(5, () => {
		tipToast.RemoveClass("IsVisisble");
		tipToast.DeleteAsync(0.3);
	});
}

function handleTipCooldown() {
	const curTime = Game.GetGameTime()

	if (curTime > nextTipTime && !tipTextIsCooldown)
		return

	const reverseState = (nextTipTime - curTime) <= 1

	for (const playerId in tipButtons) {
		const tipButton = tipButtons[playerId]

		if (reverseState) {
			tipButton.FindChildrenWithClassTraverse('TipText')[0].text = "+++"
			tipButton.SetHasClass("OnCooldown", false)

			nextTipTime = 0
			tipTextIsCooldown = false
		} else {
			tipButton.FindChildrenWithClassTraverse('TipText')[0].text = String(Math.floor(nextTipTime - curTime))
			tipButton.SetHasClass("OnCooldown", true)

			tipTextIsCooldown = true
		}
	}
}

function updateTipButtons() {
	if (playersCount !== getTopBarPlayerContainers().length)
		initTipButtons()

	handleTipCooldown()

	$.Schedule(0.5, updateTipButtons)
}

function handleActiveTipChange() {
	for (const playerId in tipButtons) {
		const tipButton = tipButtons[playerId]
		
		tipButton.SetHasClass("NoActiveTip", !activeTip)
	}
}

function activeTipChanged(netTableName, key, value) {
    if (netTableName !== "active_player_tip") return
	if (key !== localPlayerIdStr) return
	if (!value || typeof value !== "object") return

	activeTip = value.tip

	handleActiveTipChange()
}

(function () {
	if (!topBarPlayersContainer)
		return $.Msg("[TIPS] TopBarRadiantPlayersContainer not found")

	destroyOldTipButtons()
	updateTipButtons()

	GameEvents.Subscribe("success_player_tip", successTip);
	CustomNetTables.SubscribeNetTableListener("active_player_tip", activeTipChanged);
})();
