(function() {
    "use strict";

    var g_Initialized = false;
    var g_IsSpinning = false;
    var g_SpinTimeout = null;
    var SLOT_CARDS = ["SlotCard1", "SlotCard2", "SlotCard3"];
    var g_SelectedSpeed = 1; // По умолчанию x1
    var g_SelectedCurrency = "shield"; // По умолчанию щитки

    function Initialize() {
        if (g_Initialized) return;

        var root = $.GetContextPanel();
        if (!root) return;

        setupEventHandlers();
        g_Initialized = true;
    }

    function setupEventHandlers() {
        var root = $.GetContextPanel();
        var playButton = root.FindChildTraverse("PlayButton");
        if (playButton) {
            playButton.SetPanelEvent("onactivate", onPlayButtonClicked);
        }
        
        // Настройка обработчиков для кнопок скорости
        var speed1x = root.FindChildTraverse("Speed1x");
        var speed2x = root.FindChildTraverse("Speed2x");
        var speed4x = root.FindChildTraverse("Speed4x");
        
        if (speed1x) {
            speed1x.SetPanelEvent("onactivate", function() {
                setSpeed(1);
            });
        }
        
        if (speed2x) {
            speed2x.SetPanelEvent("onactivate", function() {
                setSpeed(2);
            });
        }
        
        if (speed4x) {
            speed4x.SetPanelEvent("onactivate", function() {
                setSpeed(4);
            });
        }
        
        // Устанавливаем x1 по умолчанию
        setSpeed(1);
        
        // Настройка обработчиков для кнопок выбора валюты ставки
        var betShieldChip = root.FindChildTraverse("BetShieldChip");
        var betCrystalChip = root.FindChildTraverse("BetCrystalChip");
        
        if (betShieldChip) {
            betShieldChip.SetPanelEvent("onactivate", function() {
                setSelectedCurrency("shield");
            });
        }
        
        if (betCrystalChip) {
            betCrystalChip.SetPanelEvent("onactivate", function() {
                setSelectedCurrency("crystal");
            });
        }
        
        // Устанавливаем щитки по умолчанию
        setSelectedCurrency("shield");
    }
    
    function setSpeed(speed) {
        if (g_SelectedSpeed === speed) return;
        
        var root = $.GetContextPanel();
        if (!root) return;
        
        // Убираем selected со всех кнопок
        var speed1x = root.FindChildTraverse("Speed1x");
        var speed2x = root.FindChildTraverse("Speed2x");
        var speed4x = root.FindChildTraverse("Speed4x");
        
        if (speed1x) speed1x.RemoveClass("selected");
        if (speed2x) speed2x.RemoveClass("selected");
        if (speed4x) speed4x.RemoveClass("selected");
        
        // Добавляем selected к выбранной кнопке
        var selectedButton = null;
        if (speed === 1 && speed1x) {
            selectedButton = speed1x;
        } else if (speed === 2 && speed2x) {
            selectedButton = speed2x;
        } else if (speed === 4 && speed4x) {
            selectedButton = speed4x;
        }
        
        if (selectedButton) {
            selectedButton.AddClass("selected");
            g_SelectedSpeed = speed;
            Game.EmitSound("ui_generic_button_click");
        }
    }
    
    function setSelectedCurrency(currency) {
        if (g_SelectedCurrency === currency) return;
        
        var root = $.GetContextPanel();
        if (!root) return;
        
        var betShieldChip = root.FindChildTraverse("BetShieldChip");
        var betCrystalChip = root.FindChildTraverse("BetCrystalChip");
        
        // Убираем BetSectionSelected и добавляем BetSectionUnselected ко всем
        if (betShieldChip) {
            betShieldChip.RemoveClass("BetSectionSelected");
            betShieldChip.AddClass("BetSectionUnselected");
        }
        
        if (betCrystalChip) {
            betCrystalChip.RemoveClass("BetSectionSelected");
            betCrystalChip.AddClass("BetSectionUnselected");
        }
        
        // Добавляем BetSectionSelected к выбранной валюте и убираем BetSectionUnselected
        var selectedButton = null;
        if (currency === "shield" && betShieldChip) {
            selectedButton = betShieldChip;
        } else if (currency === "crystal" && betCrystalChip) {
            selectedButton = betCrystalChip;
        }
        
        if (selectedButton) {
            selectedButton.RemoveClass("BetSectionUnselected");
            selectedButton.AddClass("BetSectionSelected");
            g_SelectedCurrency = currency;
            Game.EmitSound("ui_generic_button_click");
        }
    }

    function setupSpinTimeout() {
        if (g_SpinTimeout) {
            GameUI.LoopTime.DelTime(g_SpinTimeout);
        }
        var timeoutKey = 'spintimeout_' + Date.now() + '_' + Math.random();
        GameUI.LoopTime.AddTime(timeoutKey, 1, 10.0, function() {
            if (g_IsSpinning) finishSpin();
        }, 1);
        g_SpinTimeout = timeoutKey;
    }

    function setSpinningState(root, enabled) {
        g_IsSpinning = enabled;
        // При начале анимации кнопка неактивна до реального старта
        updatePlayButtonState(root, enabled, enabled ? false : undefined);
    }
    
    function enableSkipButton(root) {
        // Активируем кнопку пропуска когда анимация реально началась
        updatePlayButtonState(root, true, true);
    }
    
    function updatePlayButtonState(root, isSpinning, canSkip) {
        var playButton = root.FindChildTraverse("PlayButton");
        var playButtonText = root.FindChildTraverse("PlayButtonText");
        
        if (playButton) {
            if (isSpinning) {
                // Во время анимации - серый цвет и текст "ПРОПУСТИТЬ"
                playButton.AddClass("skip-mode");
                if (canSkip === true) {
                    // Анимация реально началась - другой цвет
                    playButton.AddClass("skip-active");
                } else {
                    // Анимация еще не началась - серый цвет
                    playButton.RemoveClass("skip-active");
                }
                if (playButtonText) {
                    playButtonText.text = "ПРОПУСТИТЬ";
                }
                // Кнопка активна только если анимация уже началась (canSkip = true)
                playButton.enabled = canSkip !== false;
            } else {
                // После завершения - возвращаем обычный вид
                playButton.RemoveClass("skip-mode");
                playButton.RemoveClass("skip-active");
                if (playButtonText) {
                    playButtonText.text = "ИГРАТЬ";
                }
                playButton.enabled = true;
            }
        }
    }

    function onPlayButtonClicked() {
        var root = $.GetContextPanel();
        
        if (g_IsSpinning) {
            // Если анимация идет и кнопка активна, пропускаем её
            var playButton = root.FindChildTraverse("PlayButton");
            if (playButton && playButton.enabled) {
                skipAnimation(root);
            }
            return;
        }

        clearAllSlots(root);
        setSpinningState(root, true);
        setupSpinTimeout();
        startAnticipationAnimation(root);
    }
    
    function skipAnimation(root) {
        if (!g_IsSpinning) return;
        
        // Пропускаем анимацию до конца
        stopSpinAnimation(root, true);
        finishSpin();
    }

    function startAnticipationAnimation(root) {
        var playButton = root.FindChildTraverse("PlayButton");
        if (playButton) playButton.AddClass("button-pressed");

        Game.EmitSound("ui_generic_button_click");

        for (var i = 0; i < SLOT_CARDS.length; i++) {
            var slotCard = root.FindChildTraverse(SLOT_CARDS[i]);
            if (slotCard) slotCard.AddClass("anticipation");
        }

        // Минимальная задержка для визуального эффекта anticipation
        $.Schedule(0.05, function() {
            for (var i = 0; i < SLOT_CARDS.length; i++) {
                var slotCard = root.FindChildTraverse(SLOT_CARDS[i]);
                if (slotCard) slotCard.RemoveClass("anticipation");
            }

            clearAllSlots(root);
            setSpinningState(root, true);
            setupSpinTimeout();
            GameEvents.SendCustomGameEventToServer("casino_spin", {currency: "ruby"});
        });
    }

    function onSpinResult(result) {
        if (!result.item1 || !result.item2 || !result.item3 || !result.fillerItems1 || !result.fillerItems2 || !result.fillerItems3) {
            finishSpin();
            return;
        }

        var root = $.GetContextPanel();
        
        // startAllSlotsAnimation(root, [
        //     {item: result.item1, duration: 1.0, speed: g_SelectedSpeed, fillerItems: result.fillerItems1},
        //     {item: result.item2, duration: 1.5, speed: g_SelectedSpeed, fillerItems: result.fillerItems2},
        //     {item: result.item3, duration: 2.0, speed: g_SelectedSpeed, fillerItems: result.fillerItems3}
        // ], null, finishSpin);

        startAllSlotsAnimation(root, [
            {item: "item_chest_d", duration: 0.7, speed: g_SelectedSpeed},
            {item: "item_treasure_1", duration: 1.0, speed: g_SelectedSpeed},
            {item: "item_armor_aura", duration: 1.6, speed: g_SelectedSpeed}
        ], null, finishSpin, enableSkipButton);
    }

    function finishSpin() {
        var root = $.GetContextPanel();

        if (g_SpinTimeout) {
            GameUI.LoopTime.DelTime(g_SpinTimeout);
            g_SpinTimeout = null;
        }

        for (var i = 0; i < SLOT_CARDS.length; i++) {
            var slotCard = root.FindChildTraverse(SLOT_CARDS[i]);
            if (slotCard) {
                slotCard.RemoveClass("spinning");
                slotCard.RemoveClass("winning");
                slotCard.RemoveClass("hovering");
                slotCard.RemoveClass("anticipation");
                slotCard.RemoveClass("stopped");
                slotCard.RemoveClass("slowing");
            }
        }

        // Очищаем DROP_POS после небольшой задержки, чтобы предметы успели отобразиться
        $.Schedule(0.2, function() {
            // Даем время на отображение предметов перед очисткой
        });

        setSpinningState(root, false);
    }

    GameEvents.Subscribe("casino_spin_result", onSpinResult);
    GameUI.LoopTime.Schedule(0.0, Initialize);
})();
