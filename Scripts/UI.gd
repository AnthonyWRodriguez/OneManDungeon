extends Control

var statsOpen = false
var tempLevelUp = []
var tempStatUp

onready var statsPanel = $StatsPanel
onready var smallStats = $StatsPanel/SmallStats
onready var bigStats = $StatsPanel/BigStats
onready var baseButtons = $BaseButtons
onready var topButtons = $BaseButtons/TopButtonsContainer/TopButtons
onready var bottomButtons = $BaseButtons/BottomButtonsContainer/BottomButtons
onready var statsButton = $BaseButtons/BottomButtonsContainer/BottomButtons/StatsButton
onready var levelUpButtons = $LevelUpButtons
onready var bottomLevelUpButtons = $LevelUpButtons/BottomLevelUpButtonsContainer/BottomLevelUpButtons
onready var topLevelUpButtons = $LevelUpButtons/TopLevelUpButtonsContainer/TopLevelUpButtons
onready var hpUpButton = $LevelUpButtons/TopLevelUpButtonsContainer/TopLevelUpButtons/HpUpButton
onready var atkUpButton = $LevelUpButtons/TopLevelUpButtonsContainer/TopLevelUpButtons/AtkUpButton
onready var spdUpButton = $LevelUpButtons/TopLevelUpButtonsContainer/TopLevelUpButtons/SpdUpButton
onready var defUpButton = $LevelUpButtons/TopLevelUpButtonsContainer/TopLevelUpButtons/DefUpButton
onready var resUpButton = $LevelUpButtons/TopLevelUpButtonsContainer/TopLevelUpButtons/ResUpButton
onready var stamUpButton = $LevelUpButtons/TopLevelUpButtonsContainer/TopLevelUpButtons/StamUpButton
onready var chooseLvlUpButton = $LevelUpButtons/BottomLevelUpButtonsContainer/BottomLevelUpButtons/ChooseButton
onready var addOneLvlUpButton = $LevelUpButtons/BottomLevelUpButtonsContainer/BottomLevelUpButtons/AddOneButton
onready var swordButtons = $SwordButtons
onready var simpleSwordButton = $SwordButtons/SimpleSword
onready var attackUsingSwordButton = $SwordButtons/Attack
onready var magicButtons = $MagicButtons
onready var ApplyMagicButton = $MagicButtons/Apply
onready var restButtons = $RestButtons
onready var defendButtons = $DefendButtons
onready var nextMoveButtons = $NextMoveButtons
onready var congrats = $StatsPanel/CongratsLabel
onready var statsPanelAnimation = $StatsPanel/StatsPanelAnimation
onready var lowerStats = $LowerPanel/PlayerStats
onready var lowerStatsPanel = $LowerPanel/WholePanel
onready var enemy = $'../EnemyPosition/Enemy'
onready var playerStats = $'../PlayerStats'
const battleUnits = preload("res://Resources/BattleUnits.tres")
#onready var enemy = battleUnits.enemy
#onready var playerStats = battleUnits.playerStats

func hideSmallStats():
	smallStats.hide()

func showSmallStats():
	smallStats.show()

func hideBigStats():
	bigStats.hide()

func showBigStats():
	bigStats.show()

func hideBaseTopButtons():
	topButtons.hide()

func showBaseTopButtons():
	topButtons.show()

func hideBaseBottomButtons():
	baseButtons.hide()

func showBaseBottomButtons():
	baseButtons.show()
	topButtons.hide()

func hideLowerStats():
	lowerStats.hide()

func showLowerStats():
	lowerStats.show()

func hideCongrats():
	congrats.hide()

func showCongrats():
	congrats.show()

func hideAllBaseButtons():
	baseButtons.hide()

func showAllBaseButtons():
	baseButtons.show()
	topButtons.show()
	bottomButtons.show()

func hideSwordButtons():
	swordButtons.hide()

func showSwordButtons():
	swordButtons.show()

func hideLevelUpButtons():
	levelUpButtons.hide()

func showLevelUpButtons():
	levelUpButtons.show()

func hideBottomLevelUpButtons():
	bottomLevelUpButtons.hide()

func showBottomLevelUpButtons():
	levelUpButtons.show()
	topLevelUpButtons.hide()

func hideTopLevelUpButtons():
	topLevelUpButtons.hide()

func showTopLevelUpButtons():
	levelUpButtons.show()
	topLevelUpButtons.show()

func pressSimpleSwordButton(sword):
	if(simpleSwordButton.pressed == true):
		lowerStatsPanel.text = sword.name+"\nATK: "+str(sword.atk)+" WGHT: "+str(sword.weight)
		attackUsingSwordButton.disabled = false
	else:
		lowerStatsPanel.text = ""
		attackUsingSwordButton.disabled = true

func populateLowerPanel(who, weapon):
	lowerStatsPanel.text = who+" attacked:\n"+weapon.name+"\nATK: "+str(weapon.atk)+" WGHT: "+str(weapon.weight)

func unpressAttackButtons():
	simpleSwordButton.pressed = false
	attackUsingSwordButton.disabled = true

func returnToBattleMenu():
	hideSwordButtons()
	magicButtons.hide()
	defendButtons.hide()
	restButtons.hide()
	if(statsOpen):
		contractStatsPanel()
	showAllBaseButtons()
	unpressAttackButtons()
	unpressAllMagicButtons()

func clearLowerText():
	lowerStatsPanel.text = ""

func resetAttackView():
	unpressAttackButtons()
	unpressAllActionButtons()
	returnToBattleMenu()

func enemy_died():
	hideAllBaseButtons()
	smallStats.hide()
	clearLowerText()
	congrats.show()
	playerStats.tired = 0

func updateEnemyStats():
	statsPanel.changeEnemyStamBig(enemy.stam)
	statsPanel.changeEnemyTiredBig(enemy.tired)
	enemy.hpLabel.text = "LVL"+str(enemy.lvl)+" HP"+str(enemy.hp)

func enemy_is_not_dead():
	return enemy != null

func expandStatsPanel():
	statsPanelAnimation.play("ShowAllStats")
	yield(statsPanelAnimation, "animation_finished")
	statsOpen = true

func contractStatsPanel():
	statsPanelAnimation.play("HideAllStats")
	yield(statsPanelAnimation, "animation_finished")
	statsOpen = false

func unpressAllActionButtons():
	attackUsingSwordButton.disabled = true
	ApplyMagicButton.disabled = true

func _on_StatsButton_pressed():
	var animationPlayer = find_node("StatsPanelAnimation")
	if animationPlayer:
		if(!statsOpen):
			hideAllBaseButtons()
			if enemy_is_not_dead():
				updateEnemyStats()
			expandStatsPanel()
			statsButton.text = "CLOSE"
			hideSmallStats()
			showBigStats()
			showLowerStats()
			showBaseBottomButtons()
		else:
			hideBigStats()
			hideLowerStats()
			hideAllBaseButtons()
			statsButton.text = "STATS"
			enemy.hpLabel.text = "HP"+str(enemy.hp)
			if enemy_is_not_dead():
				showSmallStats()
			contractStatsPanel()
			showAllBaseButtons()
			clearLowerText()

func _on_Cancel_pressed():
	returnToBattleMenu()
	clearLowerText()
	unpressAllActionButtons()
	unpressAllMagicButtons()

func _on_SwordButton_pressed():
	hideAllBaseButtons()
	showSwordButtons()

func _on_Enemy_activate_buttons():
	resetAttackView()

func _on_PlayerStats_lvl_changed(value):
	statsPanel.lvlLabelLower.text = "LVL\n"+str(value)
	yield(get_tree().create_timer(2), "timeout")
	expandStatsPanel()
	tempLevelUp.push_back(calculateGrowth(playerStats.hpGrowthRate))
	tempLevelUp.push_back(calculateGrowth(playerStats.atkGrowthRate))
	tempLevelUp.push_back(calculateGrowth(playerStats.spdGrowthRate))
	tempLevelUp.push_back(calculateGrowth(playerStats.defGrowthRate))
	tempLevelUp.push_back(calculateGrowth(playerStats.resGrowthRate))
	tempLevelUp.push_back(calculateGrowth(playerStats.stamGrowthRate))
	addIncrementsToBaseValues(tempLevelUp[0], tempLevelUp[1], tempLevelUp[2], tempLevelUp[3], tempLevelUp[4], tempLevelUp[5])
	decreaseProbabilities(tempLevelUp[0], tempLevelUp[1], tempLevelUp[2], tempLevelUp[3], tempLevelUp[4], tempLevelUp[5])
	populateCongratsWithLevelUp(tempLevelUp[0], tempLevelUp[1], tempLevelUp[2], tempLevelUp[3], tempLevelUp[4], tempLevelUp[5])
	showBottomLevelUpButtons()

func calculateGrowth(rate):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var random = rng.randi_range(0, 99)
	if(rate > random):
		return 1
	else:
		return 0

func returnStatString(stat, amount, growth):
	return ("\n"+stat+" "+str(amount-growth)+" + "+str(growth)+" -- "+str(amount))

func populateCongratsWithLevelUp(hp, atk, spd, def, res, stam):
	congrats.text = "You leveled up!"
	congrats.text += returnStatString("HP", playerStats.baseHp, hp)
	congrats.text += returnStatString("ATK", playerStats.baseAtk, atk)
	congrats.text += returnStatString("SPD", playerStats.baseSpd, spd)
	congrats.text += returnStatString("DEF", playerStats.baseDef, def)
	congrats.text += returnStatString("RES", playerStats.baseRes, res)
	congrats.text += returnStatString("STAM", playerStats.baseStam, stam)
	congrats.text += "\nChoose a stat\n to add 1"

func decreaseProbabilities(hp, atk, spd, def, res, stam):
	if(hp > 0):
		playerStats.hpGrowthRate -= 10
	else:
		playerStats.hpGrowthRate += 10

	if(atk > 0):
		playerStats.atkGrowthRate -= 10
	else:
		playerStats.atkGrowthRate += 10

	if(spd > 0):
		playerStats.spdGrowthRate -= 10
	else:
		playerStats.spdGrowthRate += 10

	if(def > 0):
		playerStats.defGrowthRate -= 10
	else:
		playerStats.defGrowthRate += 10

	if(res > 0):
		playerStats.resGrowthRate -= 10
	else:
		playerStats.resGrowthRate += 10

	if(stam > 0):
		playerStats.stamGrowthRate -= 10
	else:
		playerStats.stamGrowthRate += 10

func addIncrementsToBaseValues(hp, atk, spd, def, res, stam):
	playerStats.baseHp += hp
	playerStats.baseAtk += atk
	playerStats.baseSpd += spd
	playerStats.baseDef += def
	playerStats.baseRes += res
	playerStats.baseStam += stam

func unpressAllLvlButtons():
	hpUpButton.pressed = false
	atkUpButton.pressed = false
	spdUpButton.pressed = false
	defUpButton.pressed = false
	resUpButton.pressed = false
	stamUpButton.pressed = false

func pressUniqueUpButtons(button):
	unpressAllLvlButtons()
	button.pressed = true

func populateLowerTextLevelUp(statName, stat):
	lowerStatsPanel.text = "New stat\n" + statName + str(stat) + " + 1 -- " + str(stat+1) + "\nAre you sure?"

func activateAddOneButton():
	addOneLvlUpButton.disabled = false
	addOneLvlUpButton.text = "Add"

func disableAddOneButton():
	addOneLvlUpButton.disabled = true
	addOneLvlUpButton.text = ''

func resetLvlUpViewAndTempStat():
	tempStatUp = ''
	clearLowerText()
	disableAddOneButton()

func _on_ChooseCancelButton_pressed():
	if(statsOpen):
		congrats.text = "Choose 1 of the\nfollowing stats:"
		contractStatsPanel()
		showTopLevelUpButtons()
		chooseLvlUpButton.text = "Stats"
	else:
		hideTopLevelUpButtons()
		expandStatsPanel()
		populateCongratsWithLevelUp(tempLevelUp[0], tempLevelUp[1], tempLevelUp[2], tempLevelUp[3], tempLevelUp[4], tempLevelUp[5])
		resetLvlUpViewAndTempStat()
		chooseLvlUpButton.text = "Choose"
		unpressAllLvlButtons()

func _on_HpUpButton_pressed():
	if(hpUpButton.pressed):
		pressUniqueUpButtons(hpUpButton)
		tempStatUp = 'HP'
		populateLowerTextLevelUp("HP: ", playerStats.hp)
		activateAddOneButton()
	else:
		resetLvlUpViewAndTempStat()

func _on_AtkUpButton_pressed():
	if(atkUpButton.pressed):
		pressUniqueUpButtons(atkUpButton)
		tempStatUp = 'ATK'
		populateLowerTextLevelUp("ATK: ", playerStats.atk)
		activateAddOneButton()
	else:
		resetLvlUpViewAndTempStat()

func _on_SpdUpButton_pressed():
	if(spdUpButton.pressed):
		pressUniqueUpButtons(spdUpButton)
		tempStatUp = 'SPD'
		populateLowerTextLevelUp("SPD: ", playerStats.spd)
		activateAddOneButton()
	else:
		resetLvlUpViewAndTempStat()

func _on_DefUpButton_pressed():
	if(defUpButton.pressed):
		pressUniqueUpButtons(defUpButton)
		tempStatUp = 'DEF'
		populateLowerTextLevelUp("DEF: ", playerStats.def)
		activateAddOneButton()
	else:
		resetLvlUpViewAndTempStat()

func _on_ResUpButton_pressed():
	if(resUpButton.pressed):
		pressUniqueUpButtons(resUpButton)
		tempStatUp = 'RES'
		populateLowerTextLevelUp("RES: ", playerStats.res)
		activateAddOneButton()
	else:
		resetLvlUpViewAndTempStat()

func _on_StamUpButton_pressed():
	if(stamUpButton.pressed):
		pressUniqueUpButtons(stamUpButton)
		tempStatUp = 'STAM'
		populateLowerTextLevelUp("STAM: ", playerStats.stam)
		activateAddOneButton()
	else:
		resetLvlUpViewAndTempStat()

func addOneToStat(statName, stat):
	lowerStatsPanel.text = "\nYour new "+ statName + " is: " + str(stat)
	congrats.text = "What do you \nchoose next?"
	nextMoveButtons.show()

func _on_AddOneButton_pressed():
	if(tempStatUp == 'HP'):
		playerStats.baseHp += 1
		playerStats.hpGrowthRate -= 5
		addOneToStat(tempStatUp, playerStats.baseHp)
	if(tempStatUp == 'ATK'):
		playerStats.baseAtk += 1
		playerStats.atkGrowthRate -= 5
		addOneToStat(tempStatUp, playerStats.baseAtk)
	if(tempStatUp == 'SPD'):
		playerStats.baseSpd += 1
		playerStats.spdGrowthRate -= 5
		addOneToStat(tempStatUp, playerStats.baseSpd)
	if(tempStatUp == 'DEF'):
		playerStats.baseDef += 1
		playerStats.defGrowthRate -= 5
		addOneToStat(tempStatUp, playerStats.baseDef)
	if(tempStatUp == 'RES'):
		playerStats.baseRes += 1
		playerStats.resGrowthRate -= 5
		addOneToStat(tempStatUp, playerStats.baseRes)
	if(tempStatUp == 'STAM'):
		playerStats.baseStam += 1
		playerStats.stamGrowthRate -= 5
		addOneToStat(tempStatUp, playerStats.baseStam)
	hideLevelUpButtons()

func unpressAllMagicButtons():
	magicButtons.unpressAllMagicButtons()

func _on_Magic_pressed():
	hideAllBaseButtons()
	magicButtons.show()

func hideMagicButtons():
	magicButtons.hide()

func hideRestButtons():
	restButtons.hide()

func _on_Rest_pressed():
	expandStatsPanel()
	hideSmallStats()
	hideAllBaseButtons()
	congrats.show()
	congrats.text = "When resting you \nlose your turn and\nthe enemy attacks."
	congrats.text += "\n+1 ATK and SPD\n-1 DEF and RES\nCures tired by 5"
	congrats.text += "\neach consecutive\nturn you rest.\nWant to rest?"
	lowerStatsPanel.text = "Note: any alterations\nto ATK/SPD/DEF/RES\nlast only 1 turn"
	restButtons.show()

func _on_CancelRest_pressed():
	_on_Cancel_pressed()
	smallStats.show()
	congrats.hide()

func hideDefendButtons():
	defendButtons.hide()

func _on_Defend_pressed():
	expandStatsPanel()
	hideSmallStats()
	hideAllBaseButtons()
	congrats.show()
	congrats.text = "When defending you \nlose your turn and\nthe enemy attacks."
	congrats.text += "\n+1 DEF and RES\n-1 ATK and SPD\nCures tired by 2"
	congrats.text += "\neach consecutive\nturn you rest.\nWant to rest?"
	lowerStatsPanel.text = "Note: any alterations\nto ATK/SPD/DEF/RES\nlast only 1 turn"
	defendButtons.show()

func _on_CancelDefend_pressed():
	_on_Cancel_pressed()
	smallStats.show()
	congrats.hide()

func _on_Slime_activate_buttons():
	pass # Replace with function body.

func populateStats():
	congrats.text = ''
	congrats.hide()
	smallStats.show()
	statsPanel._on_PlayerStats_hp_changed(playerStats.hp)
	statsPanel._on_PlayerStats_atk_changed(playerStats.atk)
	statsPanel._on_PlayerStats_stam_changed(playerStats.stam)
	
